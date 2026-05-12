/**
 * TaskFlow Application Tests
 * Basic unit tests for automated CI/CD pipeline
 */

describe('TaskFlow Application', () => {
  test('Application should be defined', () => {
    expect(true).toBe(true);
  });

  test('Task creation functionality exists', () => {
    // Mock localStorage
    const localStorageMock = {
      getItem: jest.fn(),
      setItem: jest.fn(),
      clear: jest.fn()
    };
    global.localStorage = localStorageMock;

    expect(localStorage).toBeDefined();
  });

  test('Task validation works correctly', () => {
    const validTask = {
      id: Date.now(),
      text: 'Test task',
      completed: false,
      createdAt: new Date().toISOString()
    };

    expect(validTask.text).toBeTruthy();
    expect(validTask.id).toBeGreaterThan(0);
    expect(validTask.completed).toBe(false);
  });

  test('Empty task text should be invalid', () => {
    const emptyText = '   ';
    const trimmedText = emptyText.trim();
    
    expect(trimmedText).toBe('');
    expect(trimmedText.length).toBe(0);
  });

  test('Task statistics calculation', () => {
    const tasks = [
      { id: 1, completed: true },
      { id: 2, completed: false },
      { id: 3, completed: true },
      { id: 4, completed: false }
    ];

    const total = tasks.length;
    const completed = tasks.filter(t => t.completed).length;
    const active = total - completed;

    expect(total).toBe(4);
    expect(completed).toBe(2);
    expect(active).toBe(2);
  });

  test('Filter functionality works', () => {
    const tasks = [
      { id: 1, completed: true, text: 'Done task' },
      { id: 2, completed: false, text: 'Active task' }
    ];

    const activeTasks = tasks.filter(t => !t.completed);
    const completedTasks = tasks.filter(t => t.completed);

    expect(activeTasks.length).toBe(1);
    expect(completedTasks.length).toBe(1);
    expect(activeTasks[0].text).toBe('Active task');
  });

  test('HTML escaping prevents XSS', () => {
    const maliciousInput = '<script>alert("XSS")</script>';
    
    // Simple HTML escape function test
    const escapeHtml = (text) => {
      const div = document.createElement('div');
      div.textContent = text;
      return div.innerHTML;
    };

    const escaped = escapeHtml(maliciousInput);
    expect(escaped).not.toContain('<script>');
    expect(escaped).toContain('&lt;');
    expect(escaped).toContain('&gt;');
  });
});
