'use client';

import { Container, Typography, Box, Paper, Button } from '@mui/material';
import RestaurantIcon from '@mui/icons-material/Restaurant';

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
          py: 4,
        }}
      >
        <Paper
          elevation={3}
          sx={{
            p: 4,
            textAlign: 'center',
            borderRadius: 2,
            maxWidth: 600,
            width: '100%',
          }}
        >
          <RestaurantIcon sx={{ fontSize: 48, color: 'primary.main', mb: 2 }} />
          <Typography variant="h1" component="h1" gutterBottom>
            Macro Meal Planner
          </Typography>
          <Typography variant="h5" color="text.secondary" paragraph>
            AI-powered meal planning based on your macro goals
          </Typography>
          <Box sx={{ mt: 4 }}>
            <Button
              variant="contained"
              size="large"
              sx={{ mr: 2 }}
            >
              Get Started
            </Button>
            <Button
              variant="outlined"
              size="large"
            >
              Learn More
            </Button>
          </Box>
        </Paper>
      </Box>
    </Container>
  );
}
