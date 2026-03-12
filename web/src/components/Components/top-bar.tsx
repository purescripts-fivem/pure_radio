import { useState } from 'react';
import { useNuiEvent } from '../../hooks/useNuiEvent';
import locales from '../../locales';
import usePageStore from '../pageStore';
import Battery from './battery';
import Time from './time';

const TopBar = () => {
  const { page } = usePageStore();
  const langMap = {
    fave: locales.favorites,
    settings: locales.settings,
  };
  const [con, setCon] = useState(false);

  useNuiEvent('setConnected', (data: boolean) => setCon(data));

  return (
    <div className='rowFlex rowFlexBetween'>
      <Time />
      <h3 className='specialFont'>
        {page === 'home'
          ? con
            ? locales.connected
            : locales.noFreq
          : langMap[page as keyof typeof langMap]}
      </h3>
      <Battery />
    </div>
  );
};

export default TopBar;
