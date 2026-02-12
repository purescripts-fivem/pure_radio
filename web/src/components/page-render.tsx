import { lazy, Suspense } from 'react';
import '@/styles.scss';
import usePageStore from './pageStore';
import './Radio.scss';

const Home = lazy(() => import('./Home/index'));
const Fave = lazy(() => import('./Fave/index'));
const Settings = lazy(() => import('./Settings/index'));

const renderApp = (app: string) => {
  switch (app) {
    case 'home':
      return (
        <Suspense>
          <Home />
        </Suspense>
      );
    case 'fave':
      return (
        <Suspense>
          <Fave />
        </Suspense>
      );
    case 'settings':
      return (
        <Suspense>
          <Settings />
        </Suspense>
      );
    default:
      return <div>no app found</div>;
  }
};

const PageRender = () => {
  const { page } = usePageStore();
  return renderApp(page);
};

export default PageRender;
