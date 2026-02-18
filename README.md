# Base Strip Game

## Mainnet checklist (Base)

### 0) Preconditions

- You have **ETH on Base mainnet** for gas + the 0.0001 ETH mint price (this is real money).
- Your metadata folder is uploaded to IPFS and you have a CID like `bafy...`.
- Your JSONs are named `1.json`..`5.json` (because `tokenURI = baseTokenURI + characterId + ".json"`).

### 1) Deploy contract on Base mainnet (Remix)

1. Open Remix and select **Deploy & Run Transactions**.
2. **Environment**: `Injected Provider - MetaMask`
3. In MetaMask, switch to **Base** (chainId `8453`).
4. Compile `contracts/BaseStripGameNFT.sol`.
5. Deploy `BaseStripGameNFT` and pass constructor argument:

   `ipfs://<CID_OF_YOUR_METADATA_FOLDER>/`

   Important: **must end with `/`**.

6. After deploy, verify:
   - `MINT_PRICE()` returns `100000000000000` (wei)
   - `baseTokenURI()` returns `ipfs://<CID>/`

### 2) Quick onchain sanity checks (Remix)

- Mint test:
  - Set Remix **Value** to `100000000000000` and unit **Wei**
  - Call `mint(1)`
  - `totalSupply()` should increment
- Token metadata:
  - Call `tokenURI(1)` → should be `ipfs://<CID>/1.json`

### 3) Point frontend to the mainnet contract

In `.env` (next to `package.json`):

```env
VITE_CHAIN_ID=8453
VITE_CONTRACT_ADDRESS=<YOUR_MAINNET_CONTRACT_ADDRESS>
VITE_MINT_PRICE_ETH=0.0001
```

Restart the dev server:

```bash
npm run dev
```

### 4) Publish a public HTTPS link (for Farcaster)

You need an HTTPS URL (wallet extensions/mobile wallets won't work reliably on plain HTTP).

Two simple options:

- **Netlify (no git)**:
  - Run `npm run build`
  - Upload the `dist/` folder to Netlify (Drag & Drop)
- **Vercel (recommended)**:
  - Import the project (usually via GitHub)
  - Set the same env vars in Vercel project settings

## Notes

- Funds from mint accumulate **on the contract balance**. Owner can withdraw via `withdraw(to)`.
- If Remix “forgets” your deployed contract, re-attach it via **At Address** using the contract address on the correct network.

# React + TypeScript + Vite

This template provides a minimal setup to get React working in Vite with HMR and some ESLint rules.

Currently, two official plugins are available:

- [@vitejs/plugin-react](https://github.com/vitejs/vite-plugin-react/blob/main/packages/plugin-react) uses [Babel](https://babeljs.io/) (or [oxc](https://oxc.rs) when used in [rolldown-vite](https://vite.dev/guide/rolldown)) for Fast Refresh
- [@vitejs/plugin-react-swc](https://github.com/vitejs/vite-plugin-react/blob/main/packages/plugin-react-swc) uses [SWC](https://swc.rs/) for Fast Refresh

## React Compiler

The React Compiler is not enabled on this template because of its impact on dev & build performances. To add it, see [this documentation](https://react.dev/learn/react-compiler/installation).

## Expanding the ESLint configuration

If you are developing a production application, we recommend updating the configuration to enable type-aware lint rules:

```js
export default defineConfig([
  globalIgnores(['dist']),
  {
    files: ['**/*.{ts,tsx}'],
    extends: [
      // Other configs...

      // Remove tseslint.configs.recommended and replace with this
      tseslint.configs.recommendedTypeChecked,
      // Alternatively, use this for stricter rules
      tseslint.configs.strictTypeChecked,
      // Optionally, add this for stylistic rules
      tseslint.configs.stylisticTypeChecked,

      // Other configs...
    ],
    languageOptions: {
      parserOptions: {
        project: ['./tsconfig.node.json', './tsconfig.app.json'],
        tsconfigRootDir: import.meta.dirname,
      },
      // other options...
    },
  },
])
```

You can also install [eslint-plugin-react-x](https://github.com/Rel1cx/eslint-react/tree/main/packages/plugins/eslint-plugin-react-x) and [eslint-plugin-react-dom](https://github.com/Rel1cx/eslint-react/tree/main/packages/plugins/eslint-plugin-react-dom) for React-specific lint rules:

```js
// eslint.config.js
import reactX from 'eslint-plugin-react-x'
import reactDom from 'eslint-plugin-react-dom'

export default defineConfig([
  globalIgnores(['dist']),
  {
    files: ['**/*.{ts,tsx}'],
    extends: [
      // Other configs...
      // Enable lint rules for React
      reactX.configs['recommended-typescript'],
      // Enable lint rules for React DOM
      reactDom.configs.recommended,
    ],
    languageOptions: {
      parserOptions: {
        project: ['./tsconfig.node.json', './tsconfig.app.json'],
        tsconfigRootDir: import.meta.dirname,
      },
      // other options...
    },
  },
])
```
