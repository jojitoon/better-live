import { loginUser, signUpUser } from '@/api/auth';
import { useToast } from '@/hooks/use-toast';
import { useMutation } from '@tanstack/react-query';
import { useState } from 'react';
import { Button } from './ui/button';
import { Input } from './ui/input';

export const AuthForm = ({
  setShowAuth,
  showAuth,
}: {
  setShowAuth: React.Dispatch<React.SetStateAction<any>>;
  showAuth: string;
}) => {
  const { toast } = useToast();
  const [data, setData] = useState<{
    email: string;
    password: string;
    name?: string;
    username?: string;
  }>({
    email: '',
    password: '',
    name: '',
    username: '',
  });

  const mutation = useMutation({
    mutationFn: showAuth === 'login' ? loginUser : signUpUser,
    onSuccess: () => {
      toast({
        title:
          showAuth === 'login' ? 'Login successful' : 'Registration successful',
        description:
          showAuth === 'login'
            ? 'You have successfully logged in'
            : 'You have successfully registered',
      });
      window?.location.reload();
    },
    onError: () => {
      toast({
        title: showAuth === 'login' ? 'Login failed' : 'Registration failed',
        description:
          showAuth === 'login'
            ? 'Please check your email and password'
            : 'Please check your email and password',
      });
    },
  });
  const handleLogin = (e: any) => {
    e.preventDefault();
    if (
      !data.email ||
      !data.password ||
      (!data.username && showAuth === 'register')
    ) {
      toast({
        title: showAuth === 'login' ? 'Login failed' : 'Registration failed',
        description: 'Please fill in all fields',
      });
      return;
    }
    mutation.mutate({
      email: data.email,
      password: data.password,
      ...(showAuth === 'register' && {
        username: data.username,
      }),
    });
  };

  return (
    <div className='p-6 bg-card rounded-lg shadow-sm max-w-md mx-auto'>
      <h2 className='text-2xl font-bold mb-4'>Login</h2>
      <div className='mb-4'>
        <label htmlFor='email' className='block text-sm font-medium text-left'>
          Email
        </label>
        <Input
          type='email'
          id='email'
          className='mt-1 p-2 border rounded w-full'
          onChange={(e) => setData({ ...data, email: e.target.value })}
          value={data.email}
        />
      </div>
      {showAuth === 'register' && (
        <>
          {/* <div className='mb-4'>
              <label
                htmlFor='name'
                className='block text-sm font-medium text-left'
              >
                Name
              </label>
              <Input
                type='text'
                id='name'
                className='mt-1 p-2 border rounded w-full'
                onChange={(e) => setData({ ...data, name: e.target.value })}
                value={data.name}
              />
            </div> */}
          <div className='mb-4'>
            <label
              htmlFor='username'
              className='block text-sm font-medium text-left'
            >
              Username
            </label>
            <Input
              type='text'
              id='username'
              className='mt-1 p-2 border rounded w-full'
              onChange={(e) => setData({ ...data, username: e.target.value })}
              value={data.username}
            />
          </div>
        </>
      )}
      <div className='mb-4'>
        <label
          htmlFor='password'
          className='block text-sm font-medium text-left'
        >
          Password
        </label>
        <Input
          type='password'
          id='password'
          className='mt-1 p-2 border rounded w-full'
          onChange={(e) => setData({ ...data, password: e.target.value })}
          value={data.password}
        />
      </div>
      {showAuth === 'login' ? (
        <div className='flex gap-4 justify-center'>
          <Button onClick={handleLogin}>Login</Button>
          <Button
            onClick={() => setShowAuth('register')}
            className=' bg-primary-foreground text-primary hover:bg-primary hover:text-primary-foreground'
          >
            Register
          </Button>
        </div>
      ) : (
        <div className='flex gap-4 justify-center'>
          <Button
            onClick={() => setShowAuth('login')}
            className=' bg-primary-foreground text-primary hover:bg-primary hover:text-primary-foreground'
          >
            Login
          </Button>
          <Button onClick={handleLogin}>Register</Button>
        </div>
      )}
    </div>
  );
};
