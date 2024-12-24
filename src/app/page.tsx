'use client';

import { Container, Typography, Box } from '@mui/material';
import MacroBuilder from '@/components/MacroBuilder';

export default function Home() {
  return (
    <Box sx={{ bgcolor: 'background.default', minHeight: '100vh' }}>
      <Container maxWidth="md">
        <Box sx={{ py: 4 }}>
          <Typography 
            variant="h4" 
            component="h1" 
            gutterBottom 
            align="center" 
            sx={{ 
              mb: 4,
              fontWeight: 700,
              color: 'primary.main',
              letterSpacing: '-0.02em',
            }}
          >
            Macro Builder
          </Typography>
          <MacroBuilder />
        </Box>
      </Container>
    </Box>
  );
}
