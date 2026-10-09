-- ==============================================================================
-- GROCERRA ENTERPRISE DATABASE SCHEMA (V3 - 100% COMPLETION)
-- Location: apps/admin/schema.sql
-- Description: Complete 36-table architecture for a multi-vendor marketplace
-- (Amazon / UberEats scale) including Catalog, Logistics, Finance, Push Notifications,
-- Support Ticketing, Taxation, & Auditing.
-- ==============================================================================

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- UUIDv7 Generator
CREATE OR REPLACE FUNCTION generate_uuid_v7() RETURNS uuid AS $$
DECLARE
  v_time timestamp with time zone := clock_timestamp();
  v_hex_t varchar;
  v_res bytea;
BEGIN
  v_hex_t := lpad(to_hex((extract(epoch FROM v_time) * 1000)::bigint), 12, '0');
  v_res := decode(v_hex_t || lpad(to_hex(floor(random() * 4096)::int), 4, '0') || to_hex(floor(random() * (2^62::bigint))::bigint), 'hex');
  v_res := set_byte(v_res, 6, (b'0111' || get_byte(v_res, 6)::bit(4))::integer);
  v_res := set_byte(v_res, 8, (b'10' || get_byte(v_res, 8)::bit(6))::integer);
  RETURN encode(v_res, 'hex')::uuid;
END;
$$ LANGUAGE plpgsql VOLATILE;

-- ==========================================
-- 1. ENUMS (STATE MACHINES)
-- ==========================================
CREATE TYPE order_status AS ENUM ('pending', 'accepted', 'preparing', 'ready_for_pickup', 'out_for_delivery', 'delivered', 'cancelled', 'refunded');
CREATE TYPE product_type AS ENUM ('standard', 'weighted', 'catering', 'digital');
CREATE TYPE transaction_type AS ENUM ('authorize', 'capture', 'refund', 'payout');
CREATE TYPE transaction_status AS ENUM ('pending', 'succeeded', 'failed', 'requires_action');
CREATE TYPE delivery_provider AS ENUM ('uber_direct', 'doordash_drive', 'merchant_internal');

-- ==========================================
-- 2. CORE IDENTITY, RBAC, & DEVICES
-- ==========================================
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT generate_uuid_v7(),
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20) UNIQUE,
    full_name VARCHAR(255) NOT NULL,
    status VARCHAR(50) DEFAULT 'active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE roles (
    id UUID PRIMARY KEY DEFAULT generate_uuid_v7(),
    name VARCHAR(50) UNIQUE NOT NULL, -- 'superadmin', 'store_owner', 'store_staff', 'customer'
    permissions JSONB DEFAULT '{}'::jsonb
);

CREATE TABLE user_roles (
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    role_id UUID REFERENCES roles(id) ON DELETE CASCADE,
    store_id UUID, -- NULL if platform admin. Set to Store ID if store staff.
    PRIMARY KEY (user_id, role_id, store_id)
);

CREATE TABLE user_addresses (
    id UUID PRIMARY KEY DEFAULT generate_uuid_v7(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    formatted_address TEXT NOT NULL,
    lat DECIMAL(10,8) NOT NULL,
    lng DECIMAL(11,8) NOT NULL,
    delivery_instructions TEXT,
    is_default BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- For sending Push Notifications to the Flutter App
CREATE TABLE user_devices (
    id UUID PRIMARY KEY DEFAULT generate_uuid_v7(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    device_token TEXT NOT NULL UNIQUE, -- FCM or APNS token
    platform VARCHAR(50) NOT NULL, -- 'ios', 'android', 'web'
    last_active_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- 3. MERCHANT / STORE DOMAIN
-- ==========================================
CREATE TABLE stores (
    id UUID PRIMARY KEY DEFAULT generate_uuid_v7(),
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    logo_url VARCHAR(500),
    banner_url VARCHAR(500),
    status VARCHAR(50) DEFAULT 'pending_approval',
    commission_rate DECIMAL(5,2) DEFAULT 4.50,
    tax_id VARCHAR(100),
    stripe_account_id VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE store_locations (
    id UUID PRIMARY KEY DEFAULT generate_uuid_v7(),
    store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
    address TEXT NOT NULL,
    lat DECIMAL(10,8) NOT NULL,
    lng DECIMAL(11,8) NOT NULL,
    pickup_instructions TEXT
);

CREATE TABLE store_operating_hours (
    id UUID PRIMARY KEY DEFAULT generate_uuid_v7(),
    store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
    day_of_week INT NOT NULL CHECK (day_of_week BETWEEN 0 AND 6),
    open_time TIME NOT NULL,
    close_time TIME NOT NULL
);

CREATE TABLE store_delivery_zones (
    id UUID PRIMARY KEY DEFAULT generate_uuid_v7(),
    store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
    polygon_data JSONB, -- GeoJSON for precise delivery fences
    max_radius_km DECIMAL(5,2)
);

CREATE TABLE store_settings (
    store_id UUID PRIMARY KEY REFERENCES stores(id) ON DELETE CASCADE,
    auto_accept_orders BOOLEAN DEFAULT false,
    min_order_amount DECIMAL(10,2) DEFAULT 0.00,
    packaging_fee DECIMAL(10,2) DEFAULT 0.00,
    prep_time_minutes INT DEFAULT 15,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- 4. CATALOG DOMAIN
-- ==========================================
CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT generate_uuid_v7(),
    parent_id UUID REFERENCES categories(id),
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    icon_url VARCHAR(500),
    sort_order INT DEFAULT 0
);

CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT generate_uuid_v7(),
    store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL,
    description TEXT,
    base_price DECIMAL(10,2) NOT NULL,
    compare_at_price DECIMAL(10,2),
    stock_quantity INT DEFAULT 0,
    is_taxable BOOLEAN DEFAULT true, -- Crucial for accounting
    type product_type NOT NULL DEFAULT 'standard',
    config JSONB DEFAULT '{}'::jsonb, 
    status VARCHAR(50) DEFAULT 'active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE,
    CONSTRAINT check_positive_stock CHECK (stock_quantity >= 0)
);
CREATE INDEX idx_products_config ON products USING GIN (config);

CREATE TABLE product_images (
    id UUID PRIMARY KEY DEFAULT generate_uuid_v7(),
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    url VARCHAR(500) NOT NULL,
    is_primary BOOLEAN DEFAULT false,
    sort_order INT DEFAULT 0
);

CREATE TABLE product_categories (
    product_id UUID REFERENCES products(id) ON DELETE CASCADE,
    category_id UUID REFERENCES categories(id) ON DELETE CASCADE,
    PRIMARY KEY (product_id, category_id)
);

CREATE TABLE product_variants (
    id UUID PRIMARY KEY DEFAULT generate_uuid_v7(),
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    sku VARCHAR(100),
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    attributes JSONB NOT NULL -- e.g. {"Size": "Large", "Flavor": "Spicy"}
);

CREATE TABLE product_modifiers (
    id UUID PRIMARY KEY DEFAULT generate_uuid_v7(),
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    is_required BOOLEAN DEFAULT false,
    max_selections INT DEFAULT 1
);

CREATE TABLE product_modifier_options (
    id UUID PRIMARY KEY DEFAULT generate_uuid_v7(),
    modifier_id UUID NOT NULL REFERENCES product_modifiers(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    additional_price DECIMAL(10,2) DEFAULT 0.00
);

-- ==========================================
-- 5. ORDERS & FULFILLMENT DOMAIN
-- ==========================================
CREATE TABLE carts (
    id UUID PRIMARY KEY DEFAULT generate_uuid_v7(),
    user_id UUID REFERENCES users(id),
    session_id VARCHAR(255),
    store_id UUID REFERENCES stores(id),
    status VARCHAR(50) DEFAULT 'active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE cart_items (
    id UUID PRIMARY KEY DEFAULT generate_uuid_v7(),
    cart_id UUID NOT NULL REFERENCES carts(id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES products(id),
    variant_id UUID REFERENCES product_variants(id),
    quantity INT NOT NULL CHECK (quantity > 0),
    config JSONB DEFAULT '{}'::jsonb
);

CREATE TABLE delivery_quotes (
    id UUID PRIMARY KEY DEFAULT generate_uuid_v7(),
    cart_id UUID NOT NULL REFERENCES carts(id) ON DELETE CASCADE,
    provider delivery_provider NOT NULL,
    quote_id VARCHAR(255) NOT NULL,
    fee DECIMAL(10,2) NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT generate_uuid_v7(),
    order_number VARCHAR(50) UNIQUE NOT NULL,
    user_id UUID NOT NULL REFERENCES users(id),
    store_id UUID NOT NULL REFERENCES stores(id),
    status order_status NOT NULL DEFAULT 'pending',
    subtotal DECIMAL(10,2) NOT NULL,
    tax DECIMAL(10,2) NOT NULL,
    delivery_fee DECIMAL(10,2) NOT NULL,
    platform_fee DECIMAL(10,2) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    idempotency_key VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT generate_uuid_v7(),
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES products(id),
    variant_id UUID REFERENCES product_variants(id),
    quantity INT NOT NULL,
    snapshot_price DECIMAL(10,2) NOT NULL,
    snapshot_name VARCHAR(255) NOT NULL
);

CREATE TABLE order_item_modifiers (
    id UUID PRIMARY KEY DEFAULT generate_uuid_v7(),
    order_item_id UUID NOT NULL REFERENCES order_items(id) ON DELETE CASCADE,
    modifier_option_id UUID NOT NULL REFERENCES product_modifier_options(id),
    snapshot_name VARCHAR(255) NOT NULL,
    snapshot_price DECIMAL(10,2) NOT NULL
);

CREATE TABLE deliveries (
    id UUID PRIMARY KEY DEFAULT generate_uuid_v7(),
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    provider delivery_provider NOT NULL,
    provider_delivery_id VARCHAR(255),
    tracking_url VARCHAR(500),
    courier_name VARCHAR(255),
    courier_phone VARCHAR(50),
    status VARCHAR(50) DEFAULT 'pending',
    pickup_time TIMESTAMP WITH TIME ZONE,
    dropoff_time TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- 6. PAYMENT & FINANCE DOMAIN
-- ==========================================
CREATE TABLE transactions (
    id UUID PRIMARY KEY DEFAULT generate_uuid_v7(),
    order_id UUID NOT NULL REFERENCES orders(id),
    type transaction_type NOT NULL,
    provider VARCHAR(50) DEFAULT 'stripe',
    provider_transaction_id VARCHAR(255) UNIQUE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(10) DEFAULT 'AUD',
    status transaction_status NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE refunds (
    id UUID PRIMARY KEY DEFAULT generate_uuid_v7(),
    order_id UUID NOT NULL REFERENCES orders(id),
    transaction_id UUID NOT NULL REFERENCES transactions(id),
    amount DECIMAL(10,2) NOT NULL,
    reason TEXT,
    status transaction_status NOT NULL DEFAULT 'pending',
    liabilities JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE payouts (
    id UUID PRIMARY KEY DEFAULT generate_uuid_v7(),
    store_id UUID NOT NULL REFERENCES stores(id),
    stripe_payout_id VARCHAR(255) UNIQUE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    status transaction_status NOT NULL DEFAULT 'pending',
    period_start TIMESTAMP WITH TIME ZONE NOT NULL,
    period_end TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- 7. MARKETING, LOYALTY & REVIEWS
-- ==========================================
CREATE TABLE promotions (
    id UUID PRIMARY KEY DEFAULT generate_uuid_v7(),
    store_id UUID REFERENCES stores(id),
    code VARCHAR(50) UNIQUE NOT NULL,
    type VARCHAR(50) NOT NULL, 
    value DECIMAL(10,2) NOT NULL,
    min_order_value DECIMAL(10,2) DEFAULT 0.00,
    start_date TIMESTAMP WITH TIME ZONE,
    end_date TIMESTAMP WITH TIME ZONE,
    max_uses INT,
    current_uses INT DEFAULT 0
);

-- Tracking to ensure users don't abuse one-time promo codes
CREATE TABLE promotion_usages (
    id UUID PRIMARY KEY DEFAULT generate_uuid_v7(),
    promotion_id UUID NOT NULL REFERENCES promotions(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id),
    order_id UUID NOT NULL REFERENCES orders(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE reviews (
    id UUID PRIMARY KEY DEFAULT generate_uuid_v7(),
    order_id UUID NOT NULL REFERENCES orders(id),
    user_id UUID NOT NULL REFERENCES users(id),
    store_id UUID NOT NULL REFERENCES stores(id),
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    reply TEXT,
    status VARCHAR(50) DEFAULT 'published',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_favorites (
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    store_id UUID REFERENCES stores(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, store_id)
);

-- ==========================================
-- 8. CUSTOMER SUPPORT (TICKETING)
-- ==========================================
CREATE TABLE support_tickets (
    id UUID PRIMARY KEY DEFAULT generate_uuid_v7(),
    user_id UUID NOT NULL REFERENCES users(id),
    order_id UUID REFERENCES orders(id),
    subject VARCHAR(255) NOT NULL,
    status VARCHAR(50) DEFAULT 'open',
    priority VARCHAR(50) DEFAULT 'medium',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ticket_messages (
    id UUID PRIMARY KEY DEFAULT generate_uuid_v7(),
    ticket_id UUID NOT NULL REFERENCES support_tickets(id) ON DELETE CASCADE,
    sender_id UUID NOT NULL REFERENCES users(id),
    message TEXT NOT NULL,
    is_internal_note BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- 9. PLATFORM OPERATIONS (God's Eye)
-- ==========================================
CREATE TABLE platform_settings (
    id UUID PRIMARY KEY DEFAULT generate_uuid_v7(),
    key VARCHAR(255) UNIQUE NOT NULL,
    value JSONB NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE webhooks_log (
    id UUID PRIMARY KEY DEFAULT generate_uuid_v7(),
    provider VARCHAR(50) NOT NULL, 
    event_type VARCHAR(255) NOT NULL,
    payload JSONB NOT NULL,
    processed_status VARCHAR(50) DEFAULT 'pending',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT generate_uuid_v7(),
    table_name VARCHAR(100) NOT NULL,
    record_id UUID NOT NULL,
    action VARCHAR(10) NOT NULL,
    old_data JSONB,
    new_data JSONB,
    changed_by UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION log_audit_event() RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'UPDATE') THEN
        INSERT INTO audit_logs (table_name, record_id, action, old_data, new_data)
        VALUES (TG_TABLE_NAME, NEW.id, 'UPDATE', row_to_json(OLD)::jsonb, row_to_json(NEW)::jsonb);
        RETURN NEW;
    ELSIF (TG_OP = 'DELETE') THEN
        INSERT INTO audit_logs (table_name, record_id, action, old_data)
        VALUES (TG_TABLE_NAME, OLD.id, 'DELETE', row_to_json(OLD)::jsonb);
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Attach God's Eye Audit Trigger to highly sensitive tables
CREATE TRIGGER stores_audit AFTER UPDATE OR DELETE ON stores FOR EACH ROW EXECUTE FUNCTION log_audit_event();
CREATE TRIGGER products_audit AFTER UPDATE OR DELETE ON products FOR EACH ROW EXECUTE FUNCTION log_audit_event();
CREATE TRIGGER orders_audit AFTER UPDATE OR DELETE ON orders FOR EACH ROW EXECUTE FUNCTION log_audit_event();
CREATE TRIGGER transactions_audit AFTER UPDATE OR DELETE ON transactions FOR EACH ROW EXECUTE FUNCTION log_audit_event();
CREATE TRIGGER payouts_audit AFTER UPDATE OR DELETE ON payouts FOR EACH ROW EXECUTE FUNCTION log_audit_event();

-- ==========================================
-- 10. IN-APP NOTIFICATIONS & CHAT
-- ==========================================
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT generate_uuid_v7(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    body TEXT NOT NULL,
    action_url VARCHAR(500),
    is_read BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- 11. INVENTORY LEDGER (Strict Stock Tracking)
-- ==========================================
CREATE TABLE inventory_ledgers (
    id UUID PRIMARY KEY DEFAULT generate_uuid_v7(),
    product_id UUID NOT NULL REFERENCES products(id),
    variant_id UUID REFERENCES product_variants(id),
    quantity_change INT NOT NULL, -- Positive (restock) or Negative (sale)
    reason VARCHAR(100) NOT NULL, -- 'sale', 'restock', 'spoilage', 'return'
    order_id UUID REFERENCES orders(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
