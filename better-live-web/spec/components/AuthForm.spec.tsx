import { render, screen, fireEvent } from '@testing-library/react';
import { AuthForm } from '../src/components/AuthForm';
import { useToast } from '@/hooks/use-toast';
import { loginUser, signUpUser } from '@/api/auth';

jest.mock('@/api/auth');
jest.mock('@/hooks/use-toast');

describe('AuthForm Component', () => {
  const setShowAuth = jest.fn();

  beforeEach(() => {
    (useToast as jest.Mock).mockReturnValue({ toast: jest.fn() });
  });

  it('renders login form correctly', () => {
    render(<AuthForm setShowAuth={setShowAuth} showAuth='login' />);
    expect(screen.getByText(/Login/i)).toBeInTheDocument();
  });

  it('updates email input', () => {
    render(<AuthForm setShowAuth={setShowAuth} showAuth='login' />);
    fireEvent.change(screen.getByLabelText(/Email/i), { target: { value: 'test@example.com' } });
    expect(screen.getByLabelText(/Email/i).value).toBe('test@example.com');
  });

  it('calls loginUser on form submission', () => {
    (loginUser as jest.Mock).mockResolvedValueOnce({});
    render(<AuthForm setShowAuth={setShowAuth} showAuth='login' />);
    fireEvent.change(screen.getByLabelText(/Email/i), { target: { value: 'test@example.com' } });
    fireEvent.change(screen.getByLabelText(/Password/i), { target: { value: 'password' } });
    fireEvent.click(screen.getByText(/Login/i));
    expect(loginUser).toHaveBeenCalledWith({
      email: 'test@example.com',
      password: 'password',
    });
  });

  it('shows error when fields are empty', () => {
    render(<AuthForm setShowAuth={setShowAuth} showAuth='login' />);
    fireEvent.click(screen.getByText(/Login/i));
    expect(useToast().toast).toHaveBeenCalledWith({
      title: 'Login failed',
      description: 'Please fill in all fields',
    });
  });
});
