'use client';

import { useState } from 'react';
import { Anchor, ArrowLeft, Send, CheckCircle, Clock, ExternalLink } from 'lucide-react';
import Link from 'next/link';

const RAYLS_EMITTER = '0xe6AF1212d688601142f5E8b70da4e320d7838362';
const SEPOLIA_ROOTCHAIN = '0xe6AF1212d688601142f5E8b70da4e320d7838362';

export default function DashboardPage() {
  const [message, setMessage] = useState('');
  const [status, setStatus] = useState<'idle' | 'sending' | 'sent' | 'relayed'>('idle');
  const [txHash, setTxHash] = useState('');

  const handleSendMessage = async () => {
    if (!message.trim()) return;
    
    setStatus('sending');
    // Simulate sending - in real implementation, this would call the contract
    setTimeout(() => {
      setStatus('sent');
      setTxHash('0xb4d1aa1ad27c87907e73ab565da4660a806fbaf7b9dad5b6660b3d4305d689a8');
      
      // Simulate relayer picking it up
      setTimeout(() => {
        setStatus('relayed');
      }, 15000);
    }, 2000);
  };

  return (
    <div className="min-h-screen">
      {/* Header */}
      <header className="container mx-auto px-6 py-6 border-b border-slate-800">
        <div className="flex items-center justify-between">
          <Link href="/" className="flex items-center gap-3 hover:opacity-80 transition">
            <ArrowLeft className="w-5 h-5" />
            <Anchor className="w-8 h-8 text-purple-400" />
            <span className="text-2xl font-bold">Rayls Anchor</span>
          </Link>
          <div className="flex gap-3">
            <a
              href={`https://devnet-explorer.rayls.com/address/${RAYLS_EMITTER}`}
              target="_blank"
              rel="noopener noreferrer"
              className="px-3 py-1.5 text-sm rounded-lg bg-purple-600 hover:bg-purple-700 transition flex items-center gap-2"
            >
              Rayls Emitter <ExternalLink className="w-3 h-3" />
            </a>
            <a
              href={`https://sepolia.etherscan.io/address/${SEPOLIA_ROOTCHAIN}`}
              target="_blank"
              rel="noopener noreferrer"
              className="px-3 py-1.5 text-sm rounded-lg bg-slate-700 hover:bg-slate-600 transition flex items-center gap-2"
            >
              Sepolia RootChain <ExternalLink className="w-3 h-3" />
            </a>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="container mx-auto px-6 py-12">
        <div className="max-w-4xl mx-auto">
          <h1 className="text-4xl font-bold mb-2">Bridge Dashboard</h1>
          <p className="text-slate-400 mb-8">
            Send messages from Rayls to Ethereum and watch them get verified in real-time
          </p>

          {/* Send Message Card */}
          <div className="bg-slate-800/50 backdrop-blur rounded-2xl p-8 border border-purple-600/20 mb-8">
            <h2 className="text-2xl font-semibold mb-4 flex items-center gap-2">
              <Send className="w-6 h-6 text-purple-400" />
              Send Message to Ethereum
            </h2>
            
            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium mb-2 text-slate-300">
                  Message Content
                </label>
                <textarea
                  value={message}
                  onChange={(e) => setMessage(e.target.value)}
                  placeholder="e.g., Bank X tokenized $10M bond"
                  className="w-full px-4 py-3 rounded-lg bg-slate-900 border border-slate-700 focus:border-purple-500 focus:outline-none text-white placeholder-slate-500"
                  rows={3}
                  disabled={status !== 'idle'}
                />
              </div>

              <button
                onClick={handleSendMessage}
                disabled={!message.trim() || status !== 'idle'}
                className="w-full px-6 py-3 rounded-lg bg-gradient-to-r from-purple-600 to-pink-600 hover:from-purple-700 hover:to-pink-700 disabled:opacity-50 disabled:cursor-not-allowed text-lg font-semibold transition flex items-center justify-center gap-2"
              >
                {status === 'sending' ? (
                  <>
                    <Clock className="w-5 h-5 animate-spin" />
                    Sending to Rayls...
                  </>
                ) : (
                  <>
                    <Send className="w-5 h-5" />
                    Send Message
                  </>
                )}
              </button>
            </div>
          </div>

          {/* Status Timeline */}
          {status !== 'idle' && (
            <div className="bg-slate-800/50 backdrop-blur rounded-2xl p-8 border border-purple-600/20">
              <h2 className="text-2xl font-semibold mb-6">Message Status</h2>
              
              <div className="space-y-6">
                {/* Step 1: Sent to Rayls */}
                <div className="flex gap-4">
                  <div className="flex-shrink-0">
                    <div className={`w-10 h-10 rounded-full flex items-center justify-center ${
                      status === 'sent' || status === 'relayed' 
                        ? 'bg-green-600' 
                        : 'bg-purple-600 animate-pulse'
                    }`}>
                      {status === 'sent' || status === 'relayed' ? (
                        <CheckCircle className="w-5 h-5" />
                      ) : (
                        <Clock className="w-5 h-5" />
                      )}
                    </div>
                  </div>
                  <div className="flex-1">
                    <h3 className="font-semibold mb-1">Message Sent to Rayls</h3>
                    <p className="text-sm text-slate-400 mb-2">
                      Transaction confirmed on Rayls Devnet
                    </p>
                    {txHash && (
                      <a
                        href={`https://devnet-explorer.rayls.com/tx/${txHash}`}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="text-sm text-purple-400 hover:text-purple-300 flex items-center gap-1"
                      >
                        View Transaction <ExternalLink className="w-3 h-3" />
                      </a>
                    )}
                  </div>
                </div>

                {/* Step 2: Relayer Processing */}
                <div className="flex gap-4">
                  <div className="flex-shrink-0">
                    <div className={`w-10 h-10 rounded-full flex items-center justify-center ${
                      status === 'relayed' 
                        ? 'bg-green-600' 
                        : status === 'sent'
                        ? 'bg-purple-600 animate-pulse'
                        : 'bg-slate-700'
                    }`}>
                      {status === 'relayed' ? (
                        <CheckCircle className="w-5 h-5" />
                      ) : status === 'sent' ? (
                        <Clock className="w-5 h-5" />
                      ) : (
                        <span className="text-sm">2</span>
                      )}
                    </div>
                  </div>
                  <div className="flex-1">
                    <h3 className="font-semibold mb-1">Relayer Processing</h3>
                    <p className="text-sm text-slate-400">
                      {status === 'relayed' 
                        ? 'Checkpoint submitted to Sepolia' 
                        : status === 'sent'
                        ? 'Waiting for checkpoint interval (~10-30 seconds)...'
                        : 'Pending'}
                    </p>
                  </div>
                </div>

                {/* Step 3: Verified on Ethereum */}
                <div className="flex gap-4">
                  <div className="flex-shrink-0">
                    <div className={`w-10 h-10 rounded-full flex items-center justify-center ${
                      status === 'relayed' 
                        ? 'bg-green-600' 
                        : 'bg-slate-700'
                    }`}>
                      {status === 'relayed' ? (
                        <CheckCircle className="w-5 h-5" />
                      ) : (
                        <span className="text-sm">3</span>
                      )}
                    </div>
                  </div>
                  <div className="flex-1">
                    <h3 className="font-semibold mb-1">Verified on Ethereum</h3>
                    <p className="text-sm text-slate-400 mb-2">
                      {status === 'relayed' 
                        ? 'Checkpoint verified on Sepolia testnet' 
                        : 'Pending'}
                    </p>
                    {status === 'relayed' && (
                      <a
                        href={`https://sepolia.etherscan.io/address/${SEPOLIA_ROOTCHAIN}`}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="text-sm text-purple-400 hover:text-purple-300 flex items-center gap-1"
                      >
                        View on Sepolia <ExternalLink className="w-3 h-3" />
                      </a>
                    )}
                  </div>
                </div>
              </div>

              {status === 'relayed' && (
                <div className="mt-6 p-4 rounded-lg bg-green-600/20 border border-green-600/30">
                  <p className="text-green-400 font-semibold flex items-center gap-2">
                    <CheckCircle className="w-5 h-5" />
                    Message successfully bridged to Ethereum! 🎉
                  </p>
                  <p className="text-sm text-slate-300 mt-1">
                    Total time: ~30-45 seconds from Rayls to Ethereum verification
                  </p>
                </div>
              )}

              <button
                onClick={() => {
                  setStatus('idle');
                  setMessage('');
                  setTxHash('');
                }}
                className="mt-6 w-full px-4 py-2 rounded-lg border border-purple-600 hover:bg-purple-600/10 transition"
              >
                Send Another Message
              </button>
            </div>
          )}

          {/* Info Cards */}
          <div className="grid md:grid-cols-2 gap-6 mt-8">
            <div className="bg-slate-800/50 backdrop-blur rounded-xl p-6 border border-purple-600/20">
              <h3 className="font-semibold mb-2">How It Works</h3>
              <p className="text-sm text-slate-400">
                Messages are emitted on Rayls, bundled into checkpoints by the relayer, and verified on Ethereum using Merkle proofs. The entire process takes less than 60 seconds.
              </p>
            </div>
            <div className="bg-slate-800/50 backdrop-blur rounded-xl p-6 border border-purple-600/20">
              <h3 className="font-semibold mb-2">Demo Mode</h3>
              <p className="text-sm text-slate-400">
                This dashboard simulates the bridging process. For the live demo, use the terminal commands to send real transactions and watch the relayer in action.
              </p>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}
