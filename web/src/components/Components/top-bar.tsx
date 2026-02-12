import locales from '../../locales';
import usePageStore from '../pageStore';
import Battery from './battery';
import Time from './time';

const langMap = {
  fave: locales.favorites,
  settings: locales.settings,
};

const TopBar = () => {
  const { page } = usePageStore();
  return (
    <div className='rowFlex rowFlexBetween'>
      <Time />
      <h3 className='specialFont'>
        {page === 'home'
          ? locales.noFreq
          : langMap[page as keyof typeof langMap]}
      </h3>
      <Battery />
    </div>
  );
};

export default TopBar;
