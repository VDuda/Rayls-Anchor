import { Anchor, ArrowRight, Shield, Zap, CheckCircle } from 'lucide-react';

export default function HomePage() {
  return (
    <div className="min-h-screen">
      {/* Hero Section */}
      <header className="container mx-auto px-6 py-12">
        <nav className="flex items-center justify-between mb-16">
          <div className="flex items-center gap-3">
            <Anchor className="w-8 h-8 text-purple-400" />
            <span className="text-2xl font-bold">Rayls Anchor</span>
          </div>
          <div className="flex gap-4">
            <a
              href="https://devnet-explorer.rayls.com"
              target="_blank"
              rel="noopener noreferrer"
              className="px-4 py-2 rounded-lg bg-purple-600 hover:bg-purple-700 transition"
            >
              Rayls Explorer
            </a>
            <a
              href="https://sepolia.etherscan.io"
              target="_blank"
              rel="noopener noreferrer"
              className="px-4 py-2 rounded-lg bg-slate-700 hover:bg-slate-600 transition"
            >
              Sepolia Explorer
            </a>
          </div>
        </nav>

        <div className="max-w-5xl mx-auto text-center">
          <h1 className="text-6xl font-bold mb-6 bg-clip-text text-transparent bg-gradient-to-r from-purple-400 to-pink-600">
            Trust-Minimized Bridge
          </h1>
          <p className="text-2xl text-slate-300 mb-4">
            Bringing Rayls Public Chain to Ethereum in {'<'}60 seconds
          </p>
          <p className="text-lg text-slate-400 mb-12 max-w-3xl mx-auto">
            Polygon-inspired checkpoint system leveraging Rayls' sub-second finality for the
            fastest trust-minimized bridge ever built
          </p>

          <div className="flex gap-6 justify-center mb-16">
            <button className="px-8 py-4 rounded-lg bg-gradient-to-r from-purple-600 to-pink-600 hover:from-purple-700 hover:to-pink-700 text-lg font-semibold transition flex items-center gap-2">
              Launch Dashboard <ArrowRight className="w-5 h-5" />
            </button>
            <a
              href="https://github.com"
              className="px-8 py-4 rounded-lg border-2 border-purple-600 hover:bg-purple-600/10 text-lg font-semibold transition"
            >
              View on GitHub
            </a>
          </div>
        </div>
      </header>

      {/* Features */}
      <section className="container mx-auto px-6 py-20">
        <div className="grid md:grid-cols-3 gap-8">
          <FeatureCard
            icon={<Zap className="w-12 h-12 text-yellow-400" />}
            title="Sub-Second Finality"
            description="Checkpoints every 10-30 seconds with 60-second challenge window - impossible on Ethereum L1"
          />
          <FeatureCard
            icon={<Shield className="w-12 h-12 text-blue-400" />}
            title="Polygon-Inspired"
            description="Battle-tested checkpoint architecture with PoA validators and Merkle proof verification"
          />
          <FeatureCard
            icon={<CheckCircle className="w-12 h-12 text-green-400" />}
            title="Production Ready"
            description="Deploy on mainnet at Rayls Q1 2026 launch - built for institutional RWA flows"
          />
        </div>
      </section>

      {/* Architecture */}
      <section className="container mx-auto px-6 py-20">
        <h2 className="text-4xl font-bold text-center mb-12">How It Works</h2>
        <div className="max-w-4xl mx-auto bg-slate-800/50 backdrop-blur rounded-2xl p-8 border border-purple-600/20">
          <div className="flex items-center justify-between mb-8">
            <div className="text-center">
              <div className="w-16 h-16 mx-auto mb-3 rounded-full bg-purple-600 flex items-center justify-center">
                1
              </div>
              <p className="font-semibold">Rayls Devnet</p>
              <p className="text-sm text-slate-400">Emit Messages</p>
            </div>
            <ArrowRight className="w-8 h-8 text-purple-400" />
            <div className="text-center">
              <div className="w-16 h-16 mx-auto mb-3 rounded-full bg-pink-600 flex items-center justify-center">
                2
              </div>
              <p className="font-semibold">Relayer</p>
              <p className="text-sm text-slate-400">Sign Checkpoints</p>
            </div>
            <ArrowRight className="w-8 h-8 text-purple-400" />
            <div className="text-center">
              <div className="w-16 h-16 mx-auto mb-3 rounded-full bg-blue-600 flex items-center justify-center">
                3
              </div>
              <p className="font-semibold">Sepolia</p>
              <p className="text-sm text-slate-400">Verify Proofs</p>
            </div>
          </div>
          <div className="text-center text-slate-300">
            <p className="mb-4">
              <strong>Security Model:</strong> PoA validator signatures → 2/3+ multi-sig → zk
              light client
            </p>
            <p>
              <strong>Speed:</strong> Checkpoints every 10-30s + 60s challenge window = faster
              than any L2
            </p>
          </div>
        </div>
      </section>

      {/* Stats */}
      <section className="container mx-auto px-6 py-20">
        <div className="grid md:grid-cols-4 gap-6">
          <StatCard title="Challenge Window" value="<60s" />
          <StatCard title="Checkpoint Interval" value="10-30s" />
          <StatCard title="Chains Supported" value="2" />
          <StatCard title="Finality" value="Sub-second" />
        </div>
      </section>

      {/* Footer */}
      <footer className="container mx-auto px-6 py-12 text-center text-slate-400 border-t border-slate-800">
        <p>Built for Rayls Hackathon 2025 • Mainnet Ready Q1 2026</p>
        <p className="mt-2">
          Inspired by Polygon PoS • Powered by Rayls' sub-second finality
        </p>
      </footer>
    </div>
  );
}

function FeatureCard({
  icon,
  title,
  description,
}: {
  icon: React.ReactNode;
  title: string;
  description: string;
}) {
  return (
    <div className="p-6 rounded-xl bg-slate-800/50 backdrop-blur border border-purple-600/20 hover:border-purple-600/40 transition">
      <div className="mb-4">{icon}</div>
      <h3 className="text-xl font-semibold mb-2">{title}</h3>
      <p className="text-slate-400">{description}</p>
    </div>
  );
}

function StatCard({ title, value }: { title: string; value: string }) {
  return (
    <div className="p-6 rounded-xl bg-gradient-to-br from-purple-600/20 to-pink-600/20 backdrop-blur border border-purple-600/30 text-center">
      <p className="text-4xl font-bold mb-2">{value}</p>
      <p className="text-slate-300">{title}</p>
    </div>
  );
}
