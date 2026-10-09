export default function PromoBanner() {
  return (
    <section aria-label="Grocerra app promotion" className="bg-[var(--bg-main)] px-3 py-6 sm:px-6 sm:py-10 lg:py-14">
      <div className="mx-auto w-full max-w-[1440px]">
        <a
          aria-label="Download the Grocerra app"
          className="mx-auto block w-full max-w-[520px] overflow-hidden rounded-xl shadow-[var(--shadow-lg)] transition-transform duration-300 hover:-translate-y-1 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-4 focus-visible:outline-[var(--green-primary)] md:max-w-none"
          href="#app"
        >
          <picture className="block w-full">
            <source media="(max-width: 767px)" srcSet="/images/mob-promo.png" />
            <img
              src="/images/promo.png"
              alt="Fresh groceries delivered to your door. Download the Grocerra app now."
              width="1682"
              height="966"
              loading="lazy"
              className="block h-auto w-full"
            />
          </picture>
        </a>
      </div>
    </section>
  );
}
