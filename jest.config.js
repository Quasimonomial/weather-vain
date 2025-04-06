module.exports = {
    roots: ["<rootDir>/app/javascript"],
    testMatch: [
        "**/__tests__/**/*.+(ts|tsx|js|jsx)",
        "**/?(*.)+(spec|test).+(ts|tsx|js|jsx)"
    ],
    transform: {
        "^.+\\.(ts|tsx)$": "ts-jest",
        "^.+\\.(js|jsx)$": "babel-jest"
    },
    setupFilesAfterEnv: ["<rootDir>/jest.setup.js"],
    testEnvironment: "jsdom",
    moduleNameMapper: {
        "^@/(.*)$": "<rootDir>/app/javascript/$1",
        "\\.(css|less|scss|sass)$": "identity-obj-proxy"
    }
};
