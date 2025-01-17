export const GameCard = ({
  homeTeam,
  awayTeam,
  homeScore,
  awayScore,
  time,
}: // odds,
{
  homeTeam: string;
  awayTeam: string;
  homeScore: number;
  awayScore: number;
  time: string;
  // odds: number;
}) => {
  // show the current game - team names, score, time
  return (
    <div className='p-6 bg-card rounded-lg shadow-md mb-4'>
      <h2 className='text-lg font-semibold mb-4'>
        {homeTeam} vs {awayTeam}
      </h2>
      <p className='text-muted-foreground'>
        {homeTeam} <b className='text-black'>{homeScore}</b> -{' '}
        <b className='text-black'>{awayScore}</b> {awayTeam}
      </p>
      <p className='text-muted-foreground'>Time: {time}</p>
      {/* <p className='text-muted-foreground'>Odds: {odds}</p> */}
    </div>
  );
};
