module.exports = {
    parser: '@typescript-eslint/parser',
    extends: [
      'eslint:recommended',
      'plugin:@typescript-eslint/recommended',
      'prettier'
    ],
    plugins: ['@typescript-eslint'],
    parserOptions: {
      ecmaVersion: 2020,
      sourceType: 'module'
    },
    env: {
      node: true,
      jest: true
    },
    rules: {
      // Custom rules here
    }
};
