
const path = require("path");
const rails = require("esbuild-rails");

const watchMode = process.argv.includes("--watch");

const buildOptions = {
  entryPoints: ["app/javascript/application.ts"],
  bundle: true,
  outdir: path.join(process.cwd(), "app/assets/builds"),
  absWorkingDir: path.join(process.cwd()),
  plugins: [rails()],
  loader: {
    ".js": "jsx",
    ".ts": "tsx",
    ".tsx": "tsx",
    ".png": "file",
    ".jpg": "file",
    ".gif": "file",
    ".svg": "file",
    ".woff": "file",
    ".woff2": "file",
    ".ttf": "file",
    ".eot": "file",
    '.css': 'css'
  },
  resolveExtensions: [".ts", ".tsx", ".js", ".jsx"],
  sourcemap: process.env.RAILS_ENV !== "production"
}

if (watchMode) {
    require("esbuild").context(buildOptions).then(context => {
        context.watch();
        console.log("Watching for changes...");
}).catch(() => process.exit(1));
} else {
    require("esbuild").build(buildOptions).catch(() => process.exit(1));
}
