import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App.tsx';
import './styles.scss';
import { isEnvBrowser } from './utils/misc.ts';

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);

if (isEnvBrowser()) {
  const root = document.getElementById('root');

  // https://i.imgur.com/iPTAdYV.png - Night time img
  // https://i.imgur.com/3pzRj9n.png - Day time img
  root!.style.backgroundImage = 'url("https://i.imgur.com/3pzRj9n.png")';
  // root!.style.backgroundImage =
  // 'url("https://media.discordapp.net/attachments/789185814768386088/1304485734387941467/image.png?ex=672f9083&is=672e3f03&hm=e09d3433b9a7ddd4692b0c1fe2c8fc7ba9f47488963f6378ce9494fd5e884bbd&=&format=webp&quality=lossless&width=550&height=309")';
  root!.style.backgroundSize = 'cover';
  root!.style.backgroundRepeat = 'no-repeat';
  root!.style.backgroundPosition = 'center';
}
