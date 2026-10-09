import { Search, Bell, ChevronDown } from "lucide-react";
import Link from "next/link";

export function Header() {
  return (
    <header className="flex h-16 shrink-0 items-center justify-between border-b border-gray-200 bg-white px-6">
      <div className="flex items-center gap-4">
        {/* Store Selector (Simplified for now) */}
        <button className="flex items-center gap-2 rounded-full border border-gray-200 bg-gray-50 px-3 py-1.5 text-sm font-medium text-gray-900 transition-colors hover:bg-gray-100">
          <div className="h-2 w-2 rounded-full bg-green-500"></div>
          Madina Halal Meats
          <ChevronDown className="h-4 w-4 text-gray-500" />
        </button>
      </div>

      <div className="flex items-center gap-4">
        {/* Search */}
        <div className="relative">
          <div className="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3">
            <Search className="h-4 w-4 text-gray-400" />
          </div>
          <input
            type="text"
            className="block w-64 rounded-full border-0 bg-gray-100 py-1.5 pl-10 pr-3 text-gray-900 ring-1 ring-inset ring-transparent placeholder:text-gray-500 focus:bg-white focus:ring-2 focus:ring-inset focus:ring-black sm:text-sm sm:leading-6"
            placeholder="Search orders, products"
          />
        </div>

        {/* Notifications */}
        <button className="relative rounded-full p-1.5 text-gray-400 hover:bg-gray-100 hover:text-gray-500">
          <span className="sr-only">View notifications</span>
          <Bell className="h-5 w-5" />
          {/* Notification badge dot */}
          <span className="absolute top-1 right-1 h-2 w-2 rounded-full border-2 border-white bg-red-500"></span>
        </button>

        {/* Profile Dropdown */}
        <button className="flex h-8 w-8 items-center justify-center rounded-full bg-pink-600 text-sm font-medium text-white hover:bg-pink-700">
          AK
        </button>
      </div>
    </header>
  );
}
