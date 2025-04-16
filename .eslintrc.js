module.exports = {
    parser: '@typescript-eslint/parser',
    extends: [
      'eslint:recommended',
      'plugin:@typescript-eslint/recommended',
      'plugin:react/recommended',
      'plugin:react-hooks/recommended',
      'prettier'
    ],
    plugins: ['@typescript-eslint', 'react', 'react-hooks'],
    parserOptions: {
      ecmaVersion: 2020,
      sourceType: 'module',
      ecmaFeatures: {
        jsx: true
      }
    },
    env: {
      node: true,
      jest: true
    },
    settings: {
      react: {
        version: 'detect'
      }
    },
    rules: {
      // Custom rules here
    },
    ignorePatterns: ['app/assets/builds/*', 'node_modules/*']
};
