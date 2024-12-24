import { createTheme } from '@mui/material/styles';

const theme = createTheme({
  palette: {
    mode: 'light',
    primary: {
      main: '#FF6B42', // MacroFactor's signature orange/coral color
      light: '#FF8A6A',
      dark: '#E65B37',
    },
    secondary: {
      main: '#2C2C2E', // Dark gray used in their UI
      light: '#3A3A3C',
      dark: '#1C1C1E',
    },
    background: {
      default: '#F5F5F7', // Light gray background
      paper: '#FFFFFF',
    },
    text: {
      primary: '#2C2C2E',
      secondary: '#636366',
    },
  },
  typography: {
    fontFamily: '"SF Pro Display", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen, Ubuntu, Cantarell, "Open Sans", "Helvetica Neue", sans-serif',
    h1: {
      fontSize: '2.5rem',
      fontWeight: 700,
      letterSpacing: '-0.02em',
    },
    h2: {
      fontSize: '2rem',
      fontWeight: 700,
      letterSpacing: '-0.01em',
    },
    h3: {
      fontSize: '1.75rem',
      fontWeight: 600,
      letterSpacing: '-0.01em',
    },
    h4: {
      fontSize: '1.5rem',
      fontWeight: 600,
      letterSpacing: '-0.01em',
    },
    body1: {
      fontSize: '1rem',
      lineHeight: 1.5,
      letterSpacing: '-0.01em',
    },
    body2: {
      fontSize: '0.875rem',
      lineHeight: 1.5,
      letterSpacing: '-0.01em',
    },
  },
  components: {
    MuiButton: {
      styleOverrides: {
        root: {
          textTransform: 'none',
          borderRadius: '10px',
          fontWeight: 600,
          padding: '8px 16px',
        },
        contained: {
          boxShadow: 'none',
          '&:hover': {
            boxShadow: 'none',
          },
        },
      },
    },
    MuiCard: {
      styleOverrides: {
        root: {
          borderRadius: '16px',
          boxShadow: '0 2px 8px rgba(0, 0, 0, 0.05)',
        },
      },
    },
    MuiSlider: {
      styleOverrides: {
        root: {
          height: 6,
        },
        thumb: {
          width: 20,
          height: 20,
          '&:hover': {
            boxShadow: '0 0 0 8px rgba(255, 107, 66, 0.1)',
          },
        },
        track: {
          borderRadius: 3,
        },
        rail: {
          borderRadius: 3,
          opacity: 0.2,
        },
      },
    },
    MuiTextField: {
      styleOverrides: {
        root: {
          '& .MuiOutlinedInput-root': {
            borderRadius: '10px',
          },
        },
      },
    },
    MuiDivider: {
      styleOverrides: {
        root: {
          borderColor: 'rgba(0, 0, 0, 0.08)',
        },
      },
    },
  },
});

export default theme;
