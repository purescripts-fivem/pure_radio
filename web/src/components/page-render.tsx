import '@/styles.scss';
import usePageStore from './pageStore';
import './Radio.scss';
import Home from './Home';
import Fave from './Fave';
import Settings from './Settings';

const PageRender = () => {
  const { page } = usePageStore();
  // return renderApp(page);
  return (
    <>
      <Home show={page === 'home'} />
      <Fave show={page === 'fave'} />
      <Settings show={page === 'settings'} />
    </>
  );
};

export default PageRender;
