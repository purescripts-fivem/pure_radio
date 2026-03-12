import { useState } from 'react';
import locales from '../../locales';
import useDebounce from '../../utils/useDebounce';
import { fetchNui } from '../../utils/fetchNui';
import { useNuiEvent } from '../../hooks/useNuiEvent';

const Settings = ({ show }: { show: boolean }) => {
  const [volume, setVolume] = useState(50);
  const [clicks, setClicks] = useState(false);
  const min = 0;
  const max = 100;
  const percent = ((volume - min) / (max - min)) * 100;

  useDebounce(
    () => {
      void fetchNui('setVolumne', volume);
    },
    [volume],
    500,
  );

  useNuiEvent('setClicks', (data: boolean) => setClicks(data));

  if (!show) return null;

  return (
    <div className='radioHeight'>
      <div className='settings'>
        <h2 className='specialFont'>{locales.volume}</h2>
        <div className='rowFlex'>
          <svg
            width='0.625vw'
            height='0.625vw'
            viewBox='0 0 12 12'
            fill='none'
            xmlns='http://www.w3.org/2000/svg'>
            <path
              d='M6.71951 0.220032L3.93927 3.00002H0.74998C0.335616 3.00002 0 3.33564 0 3.75002V8.25C0 8.66406 0.335616 9 0.74998 9H3.93927L6.71951 11.7797C7.18919 12.2494 7.99979 11.9194 7.99979 11.2494V0.750655C7.99979 0.0797204 7.18856 -0.248716 6.71951 0.220032ZM10.5694 3.59752C10.2075 3.39971 9.751 3.53002 9.55038 3.89283C9.35069 4.25564 9.48288 4.71158 9.84568 4.91189C10.2491 5.13376 10.4997 5.55064 10.4997 6.00001C10.4997 6.44938 10.2491 6.86626 9.84599 7.08782C9.48319 7.28813 9.35101 7.74406 9.55069 8.10688C9.75162 8.47125 10.2085 8.60062 10.5697 8.40219C11.4519 7.91625 12 6.99594 12 5.9997C12 5.00345 11.4519 4.08345 10.5694 3.59752Z'
              fill='white'
            />
          </svg>
          <input
            style={{
              background: `linear-gradient(
          to right,
          #4E64FF 0%,
          #4E64FF ${percent}%,
          #1b1b1b ${percent}%,
          #1b1b1b 100%
        )`,
            }}
            onChange={(e) => setVolume(Number(e.target.value))}
            type='range'
            className='settingsSlider buttonClass'
            min='0'
            max='100'
          />
        </div>
      </div>
      <div className='settings settingsRow'>
        <div className='settingsCol'>
          <h2 className='specialFont'>{locales.radioClicks}</h2>
          <h3>{locales.disableClicks}</h3>
        </div>
        <div
          className='radioToggle'
          onClick={() => {
            void fetchNui('radioClicksNew', !clicks);
            setClicks((prev) => !prev);
          }}>
          <div
            className={
              clicks
                ? 'radioToggleBlob radioBlobRight'
                : 'radioToggleBlob radioBlobLeft'
            }></div>
        </div>
      </div>
    </div>
  );
};

export default Settings;
