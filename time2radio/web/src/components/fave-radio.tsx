import { fetchNui } from '../utils/fetchNui';
import { RadioType } from './fave';

const FaveRadio = ({ radio, id, setRadios }: RadioType) => {
  return (
    <div className='radioFaveItem'>
      <div className='radioFaveItemRow'>
        <svg
          onClick={() => {
            void fetchNui('joinFaveRadio', radio);
          }}
          width='0.521vw'
          height='0.926vh'
          viewBox='0 0 10 10'
          fill='none'
          xmlns='http://www.w3.org/2000/svg'>
          <path
            d='M2.85895 8.5705C2.85895 9.35998 2.21895 9.99998 1.42946 9.99998C0.639977 9.99998 0 9.35998 0 8.5705C0 7.78101 0.64 7.14101 1.42949 7.14101C2.21897 7.14101 2.85895 7.78103 2.85895 8.5705ZM6.77993 9.62518C6.59345 6.1743 3.82937 3.40674 0.374799 3.22007C0.170893 3.20904 0 3.37288 0 3.57707V4.65004C0 4.83787 0.144866 4.99539 0.332299 5.00758C2.82855 5.17017 4.82946 7.1661 4.99238 9.66766C5.00459 9.85509 5.16212 9.99996 5.34993 9.99996H6.4229C6.62712 9.99998 6.79095 9.82909 6.77993 9.62518ZM9.99977 9.63161C9.8124 4.41243 5.61305 0.188513 0.36837 0.000231938C0.166808 -0.00700018 0 0.155834 0 0.357508V1.43045C0 1.62297 0.152567 1.77967 0.344933 1.78757C4.61232 1.96255 8.03749 5.38836 8.21245 9.65507C8.22033 9.84743 8.37702 10 8.56957 10H9.64251C9.84417 9.99998 10.007 9.83317 9.99977 9.63161Z'
            fill='white'
          />
        </svg>
        <h2>{Number(radio).toFixed(2)}</h2>
      </div>
      <svg
        onClick={() => {
          fetchNui<{ ok: boolean }>('deleteRadio', id)
            .then((data) => {
              if (!data.ok) return;

              setRadios((currentRadios) =>
                currentRadios.filter((radio) => radio.id !== id)
              );
            })
            .catch((err) => console.error(err));
        }}
        className='powerOn'
        width='0.521vw'
        height='0.926vh'
        viewBox='0 0 10 10'
        fill='none'
        xmlns='http://www.w3.org/2000/svg'>
        <path
          d='M2.17135 9.24264L9.24242 2.17157L7.82821 0.757359L0.757138 7.82843L2.17135 9.24264Z'
          fill='white'
        />
        <path
          d='M9.24242 7.82843L2.17135 0.757359L0.757138 2.17157L7.82821 9.24264L9.24242 7.82843Z'
          fill='white'
        />
      </svg>
    </div>
  );
};

export default FaveRadio;
