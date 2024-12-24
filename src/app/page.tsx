import { Box, Button, Container, Typography } from '@mui/material';
import { signIn, useSession } from 'next-auth/react';

export default function Home() {
  return (
    <Container maxWidth="lg">
      <Box
        sx={{
          minHeight: '100vh',
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          justifyContent: 'center',
          textAlign: 'center',
          gap: 4,
        }}
      >
        <Typography variant="h1" component="h1" gutterBottom>
          Macro Meal Planner
        </Typography>
        <Typography variant="h2" component="h2" color="text.secondary" gutterBottom>
          AI-powered meal planning based on your macro goals
        </Typography>
        <Button
          variant="contained"
          size="large"
          onClick={() => signIn('github')}
          sx={{ mt: 4 }}
        >
          Get Started with GitHub
        </Button>
      </Box>
    </Container>
  );
}
