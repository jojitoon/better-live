import { QUERY_PATHS } from '@/lib/constants';
import { ApiCaller } from './init';

export async function loginUser(body: {
  email?: string;
  password?: string;
}): Promise<any> {
  const { data } = await ApiCaller.post(QUERY_PATHS.LOGIN, {
    ...body,
  });

  if (data?.token) {
    localStorage.setItem('TOKEN', data?.token);
  }
  return data?.data || {};
}

export async function signUpUser(body: {
  email: string;
  password: string;
  name?: string;
  username?: string;
}): Promise<any> {
  const { data } = await ApiCaller.post(QUERY_PATHS.REGISTER, {
    user: {
      ...body,
    },
  });
  if (data?.token) {
    localStorage.setItem('TOKEN', data?.token);
  }

  return data?.data || {};
}
