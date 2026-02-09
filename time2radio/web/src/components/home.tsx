import { useState } from 'react';
import { fetchNui } from '../utils/fetchNui';
import { useNuiEvent } from '../hooks/useNuiEvent';

const Home = ({ show }: { show: boolean }) => {
  const [con, setCon] = useState(false);
  const [channel, setChannel] = useState<number | undefined>(undefined);

  useNuiEvent('setRadio', (data: number) => {
    setChannel(data);
    setCon(true);
  });

  if (!show) return null;

  return (
    <>
      <div className='radioBody'>
        <input
          className='radioInput'
          type='number'
          placeholder='00.00'
          value={channel ?? ''}
          onChange={(e) => setChannel(e.target.valueAsNumber)}
          onKeyDown={(e) => {
            if (e.key === 'Enter') {
              if (!channel) return;
              void fetchNui('joinRadio', channel);
              setCon(true);
            }
          }}
        />
        <button
          onClick={() => {
            if (con) {
              setCon(false);
              setChannel(undefined);
              void fetchNui('leaveRadio');
              return;
            }

            if (!channel) return;
            void fetchNui('joinRadio', channel);
            setCon(true);
          }}>
          <h2>{con ? 'Disconnect' : 'Connect'}</h2>
        </button>
      </div>
      <svg
        onClick={() => {
          if (con) {
            void fetchNui('poweredOff');
            setCon(false);
            setChannel(undefined);
            return;
          }
        }}
        className='powerOn'
        width='1.302vw'
        height='2.315vh'
        viewBox='0 0 25 25'
        fill='none'
        xmlns='http://www.w3.org/2000/svg'>
        <path
          d='M19.1406 2.6416C22.2168 4.83887 24.2188 8.43262 24.2188 12.5C24.2188 19.1797 18.8086 24.5947 12.1338 24.6094C5.46876 24.624 0.00977454 19.1895 8.91193e-06 12.5195C-0.0048739 8.45215 1.99708 4.84863 5.06837 2.64648C5.63966 2.24121 6.43556 2.41211 6.77735 3.02246L7.54884 4.39453C7.83692 4.90723 7.7002 5.55664 7.22657 5.9082C5.2002 7.41211 3.90626 9.79492 3.90626 12.4951C3.90138 17.002 7.54395 20.7031 12.1094 20.7031C16.582 20.7031 20.3418 17.0801 20.3125 12.4463C20.2979 9.91699 19.1065 7.47559 16.9873 5.90332C16.5137 5.55176 16.3818 4.90234 16.6699 4.39453L17.4414 3.02246C17.7832 2.41699 18.5742 2.23633 19.1406 2.6416ZM14.0625 12.8906V1.17188C14.0625 0.522461 13.54 0 12.8906 0H11.3281C10.6787 0 10.1563 0.522461 10.1563 1.17188V12.8906C10.1563 13.54 10.6787 14.0625 11.3281 14.0625H12.8906C13.54 14.0625 14.0625 13.54 14.0625 12.8906Z'
          fill={con ? '#27903A' : '#902729'}
        />
      </svg>
    </>
  );
};

export default Home;
