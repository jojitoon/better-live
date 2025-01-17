import axios from 'axios';

export const ApiCaller = axios.create({
  baseURL: import.meta.env.VITE_API_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

ApiCaller.interceptors.request.use((config) => {
  const token = localStorage.getItem('TOKEN');
  console.log('token', token);

  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});
