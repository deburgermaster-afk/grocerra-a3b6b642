import React from "react";

const packages = [
  {
    title: "Eid Feast",
    status: "ACTIVE",
    price: 28,
    minGuests: 30,
    maxGuests: 200,
    items: ["Goat biryani & chicken karahi", "Seekh kebabs, naan, raita", "Kheer dessert cups"],
  },
  {
    title: "Corporate Lunch Box",
    status: "ACTIVE",
    price: 19,
    minGuests: 20,
    subtitle: "weekday delivery",
    items: ["Individual boxed lunches", "Halal chicken or veg option", "Drinks add-on available"],
  },
  {
    title: "Wedding Banquet",
    status: "ACTIVE",
    price: 42,
    minGuests: 80,
    subtitle: "staff add-on",
    items: ["Three mains, two sides", "Live naan station option", "Dessert & chai service"],
  },
  {
    title: "Party Platter",
    status: "ACTIVE",
    price: 24,
    minGuests: 20,
    subtitle: "pickup or delivery",
    items: ["Mixed grill platters", "Samosas & pakoras", "Chutneys and salad"],
  },
  {
    title: "Vegetarian Spread",
    status: "DRAFT",
    price: 22,
    minGuests: 25,
    items: ["Paneer, dal and sabzi", "Rice, naan and raita", "Gulab jamun"],
  },
];

export default function CateringPackagesPage() {
  return (
    <div className="mx-auto max-w-7xl">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between mb-8">
        <div>
          <div className="flex items-center gap-3">
            <h1 className="text-2xl font-bold tracking-tight text-gray-900">Catering packages</h1>
            <span className="inline-flex items-center rounded-md bg-gray-100 px-2 py-0.5 text-xs font-medium text-gray-600">
              SAMPLE
            </span>
          </div>
          <p className="mt-1 text-sm text-gray-500">
            5 packages • prices per guest, GST inclusive
          </p>
        </div>
        <div className="mt-4 flex sm:mt-0 sm:ml-4 space-x-3">
          <button
            type="button"
            className="inline-flex items-center rounded-full bg-white px-4 py-2 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50 transition-colors"
          >
            Quote requests
          </button>
          <button
            type="button"
            className="inline-flex items-center rounded-full bg-black px-4 py-2 text-sm font-semibold text-white shadow-sm hover:bg-gray-800 transition-colors"
          >
            New package
          </button>
        </div>
      </div>

      {/* Tabs / Filters */}
      <div className="flex space-x-2 mb-6">
        <button className="rounded-full bg-black px-4 py-1.5 text-sm font-medium text-white transition-colors">
          All · 5
        </button>
        <button className="rounded-full bg-transparent px-4 py-1.5 text-sm font-medium text-gray-600 hover:bg-gray-100 transition-colors">
          Active · 4
        </button>
        <button className="rounded-full bg-transparent px-4 py-1.5 text-sm font-medium text-gray-600 hover:bg-gray-100 transition-colors">
          Draft · 1
        </button>
      </div>

      {/* Grid */}
      <div className="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">
        {packages.map((pkg) => (
          <div
            key={pkg.title}
            className="flex flex-col justify-between overflow-hidden rounded-2xl bg-white p-6 shadow-sm ring-1 ring-gray-200 transition-shadow hover:shadow-md"
          >
            <div>
              <div className="flex items-center justify-between mb-4">
                <h3 className="text-lg font-bold text-gray-900">{pkg.title}</h3>
                <span
                  className={`inline-flex items-center rounded px-2 py-1 text-[10px] font-bold uppercase tracking-wide ${
                    pkg.status === "ACTIVE"
                      ? "bg-green-100 text-green-700"
                      : "bg-gray-100 text-gray-600"
                  }`}
                >
                  {pkg.status}
                </span>
              </div>
              <div className="mb-4">
                <p className="text-3xl font-bold text-gray-900">
                  ${pkg.price}
                  <span className="text-sm font-normal text-gray-500"> / guest · GST incl.</span>
                </p>
                <p className="mt-1 text-sm text-gray-500">
                  Min {pkg.minGuests} guests {pkg.maxGuests ? `· serves up to ${pkg.maxGuests}` : ""}
                  {pkg.subtitle ? `· ${pkg.subtitle}` : ""}
                </p>
              </div>
              
              {/* Divider */}
              <div className="my-4 border-t border-gray-100"></div>

              <ul className="space-y-2 mb-6">
                {pkg.items.map((item, idx) => (
                  <li key={idx} className="flex text-sm text-gray-600">
                    <span className="mr-2 text-gray-400">—</span>
                    {item}
                  </li>
                ))}
              </ul>
            </div>
            
            {/* Actions */}
            <div className="flex space-x-3 mt-auto">
              <button
                type="button"
                className="flex-1 rounded-full bg-white px-3 py-1.5 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50 transition-colors"
              >
                Edit
              </button>
              <button
                type="button"
                className="flex-1 rounded-full bg-white px-3 py-1.5 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50 transition-colors"
              >
                Duplicate
              </button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
