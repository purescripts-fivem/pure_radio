import { useState } from 'react';
import { useNuiEvent } from '../../hooks/useNuiEvent';

const Time = () => {
  const [time, setTime] = useState('12:12');

  useNuiEvent('setVisible', (data: string | false) => {
    if (!data) return;
    setTime(data);
    return;
  });

  return (
    <div className='rowFlex radioTopBarGap'>
      <h3 className='specialFont'>{time}</h3>
      <div className='radioTopBar'></div>
    </div>
  );
};

export default Time;
