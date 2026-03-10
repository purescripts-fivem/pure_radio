import { useState } from 'react';
import { useNuiEvent } from '../../hooks/useNuiEvent';
import { fetchNui } from '../../utils/fetchNui';

const Home = () => {
  const [con, setCon] = useState(false);
  const [channel, setChannel] = useState<number | undefined>(undefined);

  useNuiEvent('setRadio', (data: number) => {
    setChannel(data);
    setCon(true);
  });

  return (
    <div className='radioHeight'>
      <div className='frequency'>
        <input
          className='specialFont'
          type='number'
          placeholder='00.00'
          onChange={(e) => setChannel(e.target.valueAsNumber)}
          value={channel ?? ''}
          onKeyDown={(e) => {
            if (e.key === 'Enter') {
              if (!channel) return;
              fetchNui('joinRadio', channel).then((data) => {
                if (!data) return;
                setCon(true);
              });
            }
          }}
        />
      </div>
      <button
        className={`${con ? 'redButton' : 'greenButton'} connectButton`}
        onClick={() => {
          if (con) {
            setCon(false);
            setChannel(undefined);
            void fetchNui('leaveRadio');
            return;
          }

          if (!channel) return;
          fetchNui('joinRadio', channel).then((data) => {
            if (!data) return;
            setCon(true);
          });
        }}>
        <p>{con ? 'Disconnect' : 'Connect'}</p>
      </button>
    </div>
  );
};

export default Home;
