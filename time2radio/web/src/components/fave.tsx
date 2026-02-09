// import FaveRadio from './fave-radio';

import { useEffect, useState, type Dispatch, type SetStateAction } from 'react';
import { fetchNui } from '../utils/fetchNui';
import { useNuiEvent } from '../hooks/useNuiEvent';
import FaveRadio from './fave-radio';

type RadioData = {
  id: number;
  radio: number;
};

export type RadioType = RadioData & {
  setRadios: Dispatch<SetStateAction<RadioData[]>>;
};

const Fave = ({ show }: { show: boolean }) => {
  const [radios, setRadios] = useState<RadioData[]>([]);

  // fetch the player's favourite radios
  useEffect(() => {
    fetchNui<{ radios: RadioData[]; ok: boolean }>('fetchFavouriteRadios', {})
      .then((data) => {
        if (!data.ok) return;

        setRadios(data.radios);
      })
      .catch(console.error);
  }, [show]);

  useNuiEvent<RadioType[]>('setFaves', (data) => {
    setRadios(data);
  });
  if (!show) return null;
  return (
    <div className='radioBody'>
      <div className='radioMiddle radioFave'>
        <div className='radioFaveRow'>
          <h2>Favourite</h2>
          <button
            onClick={() => {
              void fetchNui('radios:setFaveRadio');
            }}>
            <svg
              width='0.417vw'
              height='0.741vh'
              viewBox='0 0 8 8'
              fill='none'
              xmlns='http://www.w3.org/2000/svg'>
              <path d='M0 4.8H8V3.2H0V4.8Z' fill='white' />
              <path d='M4.8 8V0H3.2V8H4.8Z' fill='white' />
            </svg>
          </button>
        </div>
        <div className='radioMap'>
          {radios.length > 0 ? (
            <>
              {radios.map((radio) => (
                <FaveRadio key={radio.radio} setRadios={setRadios} {...radio} />
              ))}
            </>
          ) : (
            <div className='radioMapCenter'>
              <svg
                width='27'
                height='27'
                viewBox='0 0 27 27'
                fill='none'
                xmlns='http://www.w3.org/2000/svg'>
                <path
                  d='M13.5 0C6.04234 0 0 6.04234 0 13.5C0 20.9577 6.04234 27 13.5 27C20.9577 27 27 20.9577 27 13.5C27 6.04234 20.9577 0 13.5 0ZM7.40323 10.8871C7.40323 9.92359 8.18165 9.14516 9.14516 9.14516C10.1087 9.14516 10.8871 9.92359 10.8871 10.8871C10.8871 11.8506 10.1087 12.629 9.14516 12.629C8.18165 12.629 7.40323 11.8506 7.40323 10.8871ZM17.599 20.8651C15.9006 20.3425 14.3655 20.0323 13.5 20.0323C12.6345 20.0323 11.0994 20.3425 9.40101 20.8651C8.775 21.0556 8.17621 20.5222 8.28508 19.8798C8.66613 17.7024 11.5567 16.5484 13.5 16.5484C15.4433 16.5484 18.3339 17.7079 18.7149 19.8798C18.8238 20.5276 18.2196 21.0556 17.599 20.8651ZM17.8548 12.629C16.8913 12.629 16.1129 11.8506 16.1129 10.8871C16.1129 9.92359 16.8913 9.14516 17.8548 9.14516C18.8183 9.14516 19.5968 9.92359 19.5968 10.8871C19.5968 11.8506 18.8183 12.629 17.8548 12.629Z'
                  fill='#909091'
                />
              </svg>
              <h1>Empty</h1>
              <h3>You don't have any</h3>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default Fave;
