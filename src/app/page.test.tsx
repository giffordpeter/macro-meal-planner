import { render, screen } from '@testing-library/react';
import Home from './page';

describe('Home', () => {
  it('renders the title', () => {
    render(<Home />);
    const title = screen.getByText('Macro Meal Planner');
    expect(title).toBeInTheDocument();
  });

  it('renders the coming soon text', () => {
    render(<Home />);
    const text = screen.getByText('Coming soon...');
    expect(text).toBeInTheDocument();
  });
});
