import { clsx, type ClassValue } from 'clsx';
import { twMerge } from 'tailwind-merge';

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

export function formatTime(time: number) {
  const minutes = Math.floor(time / 60);
  const seconds = time % 60;
  return `${minutes}:${seconds < 10 ? `0${seconds}` : seconds}`;
}

export const constructEventMessage = (
  type: string,
  seconds: number,
  player: string,
  team: string
) => {
  switch (type) {
    case 'goal':
      return `${player} scores a goal in the ${getMinuteInTh(
        seconds
      )} seconds for the ${team} team`;
    case 'yellow-card':
      return `${player} from the ${team} team gets a yellow card in the ${getMinuteInTh(
        seconds
      )} seconds `;
    case 'red-card':
      return `${player} from the ${team} team gets a red card in the ${getMinuteInTh(
        seconds
      )} seconds `;
    case 'substitution':
      return `${player} from the ${team} team gets a substitution in the ${getMinuteInTh(
        seconds
      )} seconds `;
    case 'injury':
      return `${player} from the ${team} team gets injured in the ${getMinuteInTh(
        seconds
      )} seconds `;
    case 'penalty':
      return `${player} from the ${team} team scores a penalty in the ${getMinuteInTh(
        seconds
      )} seconds `;
    case 'penalty-caused':
      return `${player} from the ${team} team causes a penalty in the ${getMinuteInTh(
        seconds
      )} seconds `;
    default:
      return '';
  }
};

export function getMinuteInTh(seconds: number) {
  const minute = Math.floor(seconds / 60);
  if (minute === 1) {
    return '1st';
  } else if (minute === 2) {
    return '2nd';
  } else if (minute === 3) {
    return '3rd';
  } else {
    return `${minute}th`;
  }
}
