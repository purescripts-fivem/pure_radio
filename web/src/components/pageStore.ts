import { create } from 'zustand';

type PageStoreType = {
  page: string;
  setPage: (data: string) => void;
};

const usePageStore = create<PageStoreType>((set) => ({
  page: 'home',
  setPage: (data: string) => {
    set({ page: data });
  },
}));

export default usePageStore;
