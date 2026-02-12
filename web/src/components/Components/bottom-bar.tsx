import usePageStore from '../pageStore';
import { NavIcons } from './nav-icons';

const navMap = ['home', 'fave', 'settings'];

const BottomBar = () => {
  const { page, setPage } = usePageStore();
  return (
    <div className='rowFlex bottomBarFlex'>
      {navMap.map((nav) => (
        <button
          onClick={() => setPage(nav)}
          className={`bottomCircle buttonClass ${page === nav && 'bottomCircleBlue'}`}
          key={nav}>
          {NavIcons(nav)}
        </button>
      ))}
    </div>
  );
};

export default BottomBar;
