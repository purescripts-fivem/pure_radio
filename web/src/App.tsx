import { useEffect, useState } from 'react';
import { useNuiEvent } from './hooks/useNuiEvent';
import NuiEvents from './utils/nuiEvents';
import { debugData } from './utils/debugData';
import { fetchNui } from './utils/fetchNui';
import locales, { setLocale } from './locales';
import Config, { setConfig } from './config';

debugData(
  [
    {
      action: 'setVisible',
      data: true,
    },
  ],
  1000,
);

function App() {
  const [visible, setVisible] = useState<boolean>(false);
  const [anim, setAnim] = useState<boolean>(false);

  const hideUi = () => {
    setAnim(false);
    setTimeout(() => {
      setVisible(false);
      void fetchNui('exit');
    }, 500);
  };

  useNuiEvent('setVisible', (data: boolean) => {
    if (!data) return hideUi();
    setAnim(true);
    setVisible(true);
    return;
  });

  const handleESC = (e: KeyboardEvent) => {
    if (e.key !== 'Escape') return;
    hideUi();
  };

  useNuiEvent(
    'setInitData',
    (data: { locales: typeof locales; config: typeof Config }) => {
      setLocale(data.locales);
      setConfig(data.config);
    },
  );

  useEffect(() => {
    window.addEventListener('keydown', handleESC);
    return () => window.removeEventListener('keydown', handleESC);
  }, []);

  return (
    <>
      <div
        className='container'
        style={{
          display: visible ? 'flex' : 'none',
        }}></div>
      <NuiEvents />
    </>
  );
}

export default App;
