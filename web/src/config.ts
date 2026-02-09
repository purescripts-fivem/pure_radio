import { isEnvBrowser } from './utils/misc';
// import locale from '~/locales/en.json';
import configJson from './debug/debugConfig.json';

let Config: typeof configJson = configJson;

export function setConfig(data: typeof configJson) {
  Config = data;
}

if (isEnvBrowser()) {
  Config = configJson;
}

export const GetConfig = (): typeof configJson => {
  return Config;
};

export default Config as typeof configJson;
