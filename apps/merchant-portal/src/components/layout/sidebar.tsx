"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import {
  LayoutDashboard,
  ShoppingCart,
  Box,
  Store,
  UtensilsCrossed,
  Tags,
  Wallet,
  BarChart4,
  Users,
  LifeBuoy,
  ChevronDown,
  ChevronRight,
} from "lucide-react";
import { useState, useEffect } from "react";

const navigation = [
  { name: "Dashboard", href: "/", icon: LayoutDashboard },
  { name: "Orders", href: "/orders", icon: ShoppingCart, count: 3 },
  { name: "Catalogue", href: "/catalogue", icon: Box, hasChildren: true, children: [{ name: "Products", href: "/catalogue/products" }, { name: "Categories", href: "/catalogue/categories" }] },
  { name: "Store", href: "/store", icon: Store, hasChildren: true, children: [{ name: "Settings", href: "/store/settings" }, { name: "Locations", href: "/store/locations" }] },
  {
    name: "Catering",
    href: "/catering",
    icon: UtensilsCrossed,
    hasChildren: true,
    children: [
      { name: "Quote Requests", href: "/catering/quotes/requests", count: 2 },
      { name: "Packages", href: "/catering/packages" },
      { name: "Quotes", href: "/catering/quotes" },
      { name: "Calendar", href: "/catering/calendar" },
    ],
  },
  { name: "Promotions", href: "/promotions", icon: Tags },
  { name: "Finance", href: "/finance", icon: Wallet, hasChildren: true, children: [{ name: "Payouts", href: "/finance/payouts" }, { name: "Transactions", href: "/finance/transactions" }] },
  { name: "Reports", href: "/reports", icon: BarChart4 },
  { name: "Staff & Permissions", href: "/staff", icon: Users },
  { name: "Support", href: "/support", icon: LifeBuoy, hasChildren: true, children: [{ name: "Tickets", href: "/support/tickets" }, { name: "Help Center", href: "/support/help" }] },
];

export function Sidebar() {
  const pathname = usePathname();
  const [openMenu, setOpenMenu] = useState<string | null>(() => {
    const activeMenu = navigation.find(
      (item) => item.hasChildren && pathname.startsWith(item.href) && item.href !== "/"
    );
    return activeMenu ? activeMenu.name : null;
  });

  useEffect(() => {
    const activeMenu = navigation.find(
      (item) => item.hasChildren && pathname.startsWith(item.href) && item.href !== "/"
    );
    if (activeMenu) {
      setOpenMenu(activeMenu.name);
    }
  }, [pathname]);

  const toggleMenu = (name: string) => {
    setOpenMenu(prev => (prev === name ? null : name));
  };

  return (
    <div className="flex h-full w-64 flex-col overflow-y-auto border-r border-gray-200 bg-white">
      {/* Brand */}
      <div className="flex h-16 shrink-0 items-center px-6">
        <span className="text-xl font-bold tracking-tight text-gray-900">
          GROCERRA
        </span>
      </div>

      {/* Navigation */}
      <nav className="flex-1 space-y-1 px-3 py-4">
        {navigation.map((item) => {
          const isActive = pathname.startsWith(item.href) && item.href !== "/" || (pathname === "/" && item.href === "/");
          const isExpanded = openMenu === item.name;

          return (
            <div key={item.name}>
              {item.hasChildren ? (
                <button
                  onClick={() => toggleMenu(item.name)}
                  className={`group flex w-full items-center justify-between rounded-md px-3 py-2 text-sm font-medium transition-colors ${
                    isActive || isExpanded
                      ? "bg-gray-100 text-gray-900"
                      : "text-gray-600 hover:bg-gray-50 hover:text-gray-900"
                  }`}
                >
                  <div className="flex items-center">
                    <item.icon
                      className={`mr-3 h-5 w-5 shrink-0 ${
                        isActive || isExpanded ? "text-gray-900" : "text-gray-400 group-hover:text-gray-500"
                      }`}
                      aria-hidden="true"
                    />
                    {item.name}
                  </div>
                  {isExpanded ? (
                    <ChevronDown className="ml-auto h-4 w-4 text-gray-400" />
                  ) : (
                    <ChevronRight className="ml-auto h-4 w-4 text-gray-400" />
                  )}
                </button>
              ) : (
                <Link
                  href={item.href}
                  className={`group flex items-center justify-between rounded-md px-3 py-2 text-sm font-medium transition-colors ${
                    isActive
                      ? "bg-gray-100 text-gray-900"
                      : "text-gray-600 hover:bg-gray-50 hover:text-gray-900"
                  }`}
                >
                  <div className="flex items-center">
                    <item.icon
                      className={`mr-3 h-5 w-5 shrink-0 ${
                        isActive ? "text-gray-900" : "text-gray-400 group-hover:text-gray-500"
                      }`}
                      aria-hidden="true"
                    />
                    {item.name}
                  </div>
                  {item.count && (
                    <span className="ml-auto inline-block rounded-full bg-black px-2 py-0.5 text-xs font-semibold text-white">
                      {item.count}
                    </span>
                  )}
                </Link>
              )}
              
              {/* Children (if expanded) */}
              {item.children && isExpanded && (
                <div className="mt-1 space-y-1 pl-11 pr-3">
                  {item.children.map((child) => {
                    const isChildActive = pathname === child.href;
                    return (
                      <Link
                        key={child.name}
                        href={child.href}
                        className={`group flex items-center justify-between rounded-md px-3 py-2 text-sm font-medium transition-colors ${
                          isChildActive
                            ? "bg-black text-white"
                            : "text-gray-600 hover:bg-gray-50 hover:text-gray-900"
                        }`}
                      >
                        {child.name}
                        {child.count && (
                          <span
                            className={`ml-auto inline-block rounded-full px-2 py-0.5 text-xs font-semibold ${
                              isChildActive ? "bg-white text-black" : "bg-black text-white"
                            }`}
                          >
                            {child.count}
                          </span>
                        )}
                      </Link>
                    );
                  })}
                </div>
              )}
            </div>
          );
        })}
      </nav>

      {/* Footer / Status */}
      <div className="border-t border-gray-200 p-4">
        <div className="flex items-center rounded-md bg-gray-50 px-3 py-2">
          <div className="mr-2 h-2 w-2 rounded-full bg-green-500"></div>
          <div>
            <p className="text-sm font-medium text-gray-900">Open</p>
            <p className="text-xs text-gray-500">Accepting orders - closes 10:00 PM</p>
          </div>
        </div>
      </div>
    </div>
  );
}
