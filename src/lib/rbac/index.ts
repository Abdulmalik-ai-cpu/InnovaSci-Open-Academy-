/**
 * InnovaSci Open Academy - RBAC & PBAC Exports
 */

export * from './roles';
export * from './pbac';

// Re-export for convenience
import * as RBAC from './roles';
import * as PBAC from './pbac';

export { RBAC, PBAC };
