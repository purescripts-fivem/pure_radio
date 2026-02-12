import { useEffect, useState } from 'react';
import locales from '../../locales';
import FaveRadio from './fave-radio';
import { useNuiEvent } from '../../hooks/useNuiEvent';
import { fetchNui } from '../../utils/fetchNui';

export type RadioData = {
  id: number;
  radio: number;
};

const Fave = () => {
  const [radios, setRadios] = useState<RadioData[]>([]);
  useEffect(() => {
    fetchNui<RadioData[]>('fetchFavouriteRadios')
      .then((data) => {
        if (!data) return;

        setRadios(data);
      })
      .catch(console.error);
  }, []);

  useNuiEvent<RadioData[]>('setFaves', (data) => {
    setRadios(data);
  });

  return (
    <div className='radioHeight'>
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
    </div>
  );
};

export default Fave;
