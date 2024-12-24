'use client';

import { Container, Typography, Box } from '@mui/material';
import MacroBuilder from '@/components/MacroBuilder';

export default function Home() {
  return (
    <Container maxWidth="md">
      <Box
        sx={{
          minHeight: '100vh',
          py: 4,
        }}
      >
        <Typography variant="h4" component="h1" gutterBottom align="center" sx={{ mb: 4 }}>
          Macro Meal Planner
        </Typography>
        <MacroBuilder />
      </Box>
    </Container>
  );
}
