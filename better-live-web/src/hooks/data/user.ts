import { getMe, User } from '@/api/user';
import { QUERY_PATHS } from '@/lib/constants';
import { QueryOptions, useQuery } from '@tanstack/react-query';

export const useMe = (options?: QueryOptions) => {
  return useQuery<any, any, User>({
    queryKey: [QUERY_PATHS.GET_USER],
    queryFn: () => getMe(),
    retryDelay: 3000,
    ...(options || {}),
  });
};
