import { lazy, Suspense } from 'react';
import '@/styles.scss';
import usePageStore from './pageStore';

// const Home = lazy(() => import('./Apps/Home/index'));

const renderApp = (app: string) => {
  switch (app) {
    case 'home':
      return <Suspense>{/* <Home /> */}</Suspense>;
    default:
      return <div>no app found</div>;
  }
};

const PageRender = () => {
  const { page } = usePageStore();
  return renderApp(page);
};

export default PageRender;
