const waitlist = "mailto:hello@grocerra.com?subject=Grocerra%20waitlist&body=Add%20me%20to%20the%20Grocerra%20launch%20list.%20My%20suburb%3A%20"

const features = [
  { title: "Fresh groceries", body: "Fruit and veg, pantry staples, snacks and sweets from independent stores near you." },
  { title: "Quality meat and fish", body: "Fresh cuts from local butchers and fishmongers, weighed and packed to order." },
  { title: "Catering for any occasion", body: "Request a quote for weddings, celebrations and family gatherings from trusted local caterers." },
  { title: "On-demand delivery", body: "Not a delivery window next Thursday. Your order is picked up and brought to your door within the hour." },
]
const steps = ["Choose your local store", "Fill your basket", "Pay securely in the app", "Track your courier live"]

export default function Home() {
  return (
    <>
      <header className="bar">
        <a className="brand" href="#top">Grocerra</a>
        <a className="btn small" href="#waitlist">Join the waitlist</a>
      </header>
      <main id="top">
        <section className="hero">
          <p className="eyebrow">Launching in Melbourne · December 2026</p>
          <h1>Fresh groceries and catering, delivered to you.</h1>
          <p className="lede">Order from independent local stores and caterers, brought to your door within the hour.</p>
          <a className="btn" href="#waitlist">Get early access</a>
        </section>
        <section className="grid" aria-label="What Grocerra offers">
          {features.map((item) => <article key={item.title}><h2>{item.title}</h2><p>{item.body}</p></article>)}
        </section>
        <section className="steps">
          <h2>How it works</h2>
          <ol>{steps.map((step) => <li key={step}>{step}</li>)}</ol>
        </section>
        <section className="stores">
          <h2>Own a store or catering business?</h2>
          <p>Reach customers who are already looking for you, with fair commission and no delivery fleet to run.</p>
          <a className="btn light" href="mailto:hello@grocerra.com?subject=Grocerra%20for%20merchants">Talk to us</a>
        </section>
        <section className="cta" id="waitlist">
          <h2>Be first in line</h2>
          <p>Join the launch list and get a welcome offer when we open in your suburb.</p>
          <a className="btn" href={waitlist}>Join the waitlist</a>
        </section>
      </main>
      <footer><span>© {new Date().getFullYear()} Grocerra · Melbourne, Australia</span></footer>
    </>
  )
}
