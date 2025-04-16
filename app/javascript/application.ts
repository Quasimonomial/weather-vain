// Entry point for the build script in your package.json
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap-icons/font/bootstrap-icons.css';

import React from 'react';
import { createRoot } from 'react-dom/client';

import WeatherVain from './src/WeatherVain';

document.addEventListener('DOMContentLoaded', () => {
  const container = document.getElementById('root');

  if (container) {
    const root = createRoot(container);
    root.render(React.createElement(WeatherVain));
  }
});
