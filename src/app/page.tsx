'use client';

import { Container, Typography, Box } from '@mui/material';
import MacroBuilder from '@/components/MacroBuilder';

export default function Home() {
  return (
    <Container maxWidth="md">
      <Box sx={{ py: 4 }}>
        <Typography 
          variant="h4" 
          component="h1" 
          gutterBottom 
          align="center" 
          sx={{ 
            mb: 4,
            fontWeight: 600,
            color: (theme) => theme.palette.primary.main 
          }}
        >
          Macro Builder
        </Typography>
        <MacroBuilder />
      </Box>
    </Container>
  );
}
