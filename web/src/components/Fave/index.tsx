import { useEffect, useState } from 'react';
import locales from '../../locales';
import FaveRadio from './fave-radio';
import { useNuiEvent } from '../../hooks/useNuiEvent';
import { fetchNui } from '../../utils/fetchNui';

export type RadioData = {
  id: number;
  radio: number;
};

const Fave = ({ show }: { show: boolean }) => {
  const [radios, setRadios] = useState<RadioData[]>([]);
  useEffect(() => {
    fetchNui<RadioData[]>('fetchFavouriteRadios')
      .then((data) => {
        if (!data) return setRadios([]);
        if (data.length === 0) return setRadios([]);
        setRadios(data);
      })
      .catch((error) => console.log('fetchFavouriteRadios error: ', error));
  }, []);

  useNuiEvent<RadioData[]>('setFaves', (data) => {
    if (!data) return setRadios([]);
    if (data.length === 0) return setRadios([]);
    setRadios(data);
  });

  if (!show) return null;

  return (
    <div className='radioHeight'>
      {radios.length > 1 ? (
        <>
          <div className='faveFlex'>
            {radios.map((radio) => (
              <FaveRadio {...radio} setRadios={setRadios} />
            ))}
          </div>
          <button
            className='faveAdd buttonClass blueButton'
            onClick={() => {
              void fetchNui('addFaveRadio');
            }}>
            <p className='specialFont'>{locales.addPlus}</p>
          </button>
        </>
      ) : (
        <>
          <div className='radioCenter'>
            <svg
              width='1.146vw'
              height='1.146vw'
              viewBox='0 0 22 22'
              fill='none'
              xmlns='http://www.w3.org/2000/svg'>
              <path
                d='M11 0C4.92339 0 0 4.92339 0 11C0 17.0766 4.92339 22 11 22C17.0766 22 22 17.0766 22 11C22 4.92339 17.0766 0 11 0ZM6.03226 8.87097C6.03226 8.08589 6.66653 7.45161 7.45161 7.45161C8.23669 7.45161 8.87097 8.08589 8.87097 8.87097C8.87097 9.65605 8.23669 10.2903 7.45161 10.2903C6.66653 10.2903 6.03226 9.65605 6.03226 8.87097ZM14.3399 17.0012C12.956 16.5754 11.7052 16.3226 11 16.3226C10.2948 16.3226 9.04395 16.5754 7.66008 17.0012C7.15 17.1565 6.6621 16.7218 6.75081 16.1984C7.06129 14.4242 9.41653 13.4839 11 13.4839C12.5835 13.4839 14.9387 14.4286 15.2492 16.1984C15.3379 16.7262 14.8456 17.1565 14.3399 17.0012ZM14.5484 10.2903C13.7633 10.2903 13.129 9.65605 13.129 8.87097C13.129 8.08589 13.7633 7.45161 14.5484 7.45161C15.3335 7.45161 15.9677 8.08589 15.9677 8.87097C15.9677 9.65605 15.3335 10.2903 14.5484 10.2903Z'
                fill='white'
                fill-opacity='0.5'
              />
            </svg>
            <h1 className='specialFont'>{locales.noFaveRadios}</h1>
            <button
              className='faveAdd buttonClass blueButton'
              onClick={() => {
                void fetchNui('addFaveRadio');
              }}>
              <p className='specialFont'>{locales.addPlus}</p>
            </button>
          </div>
        </>
      )}
    </div>
  );
};

export default Fave;
