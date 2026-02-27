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
