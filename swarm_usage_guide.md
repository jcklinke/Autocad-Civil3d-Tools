# Claude Swarm Usage Guide - AutoCAD Civil 3D Tools

## Quick Start

The Claude swarm has been successfully initialized for this AutoCAD Civil 3D tools project. Here's how to leverage the swarm configuration for development tasks.

## Swarm Configuration Summary

✅ **Initialized**: Claude Flow swarm with hierarchical topology  
✅ **Max Agents**: 8 specialized agents  
✅ **Strategy**: Adaptive execution with auto-spawning  
✅ **GitHub Integration**: Enabled with build automation  
✅ **Monitoring**: Active with performance tracking  

## Using the Swarm

### For Simple Tasks
For straightforward development tasks that don't require coordination across multiple projects, you can work with Claude directly:

```bash
claude "Add a new helper method to the UtilitiesCommonSHARED project"
```

### For Complex Multi-Project Tasks
For tasks involving multiple projects or shared components, reference the swarm configuration:

```bash
claude "Using the swarm configuration, implement a new hydraulic calculation feature that spans DimensioneringV2 and NorsynHydraulicShared projects"
```

### For Cross-Team Coordination
When you need multiple specialists working together:

```bash
claude "Coordinate between the Core AutoCAD Developer and Civil 3D Specialist to refactor the pipe network integration"
```

## Agent Specializations

### 🎯 Core AutoCAD Developer (25% allocation)
- **Expertise**: AutoCAD API, shared utilities, base functionality
- **Projects**: IntersectUtilities, AutoCADCommands, AcadOverrules
- **Invoke with**: "As the Core AutoCAD Developer..."

### 🚰 Civil 3D Specialist (25% allocation)  
- **Expertise**: Civil 3D API, hydraulic modeling, pipe networks
- **Projects**: DimensioneringV2, Dimensionering, NorsynHydraulicCalc
- **Invoke with**: "As the Civil 3D Specialist..."

### 📊 Data Integration Developer (15% allocation)
- **Expertise**: External data formats, import/export workflows
- **Projects**: LERImporter, ExportShapeFiles, ReverseLayoutProfileLANDXML
- **Invoke with**: "As the Data Integration Developer..."

### 🎨 UI/UX Developer (10% allocation)
- **Expertise**: WPF, AutoCAD palettes, user interfaces
- **Projects**: DriPaletteSet, FormsSHARED
- **Invoke with**: "As the UI/UX Developer..."

### ⚙️ Automation Specialist (10% allocation)
- **Expertise**: Process automation, batch operations
- **Projects**: SheetCreationAutomation, AcCoreConsoleAutomation
- **Invoke with**: "As the Automation Specialist..."

### 🎬 Graphics & Export Specialist (10% allocation)
- **Expertise**: Graphics rendering, visualization, export formats
- **Projects**: ExportBlocksToSvg, IsoTools
- **Invoke with**: "As the Graphics & Export Specialist..."

### 🧪 Testing & QA Specialist (5% allocation)
- **Expertise**: Testing, quality assurance, documentation
- **Projects**: DocsCreateCommandDescriptionsHtml
- **Invoke with**: "As the Testing & QA Specialist..."

## Example Workflows

### 1. Adding a New Feature
```
Input: "I need to add a new pipe sizing algorithm to the hydraulic calculation system"

Expected Flow:
1. Coordinator analyzes requirements
2. Civil 3D Specialist implements core algorithm
3. Core AutoCAD Developer updates shared utilities if needed
4. UI/UX Developer creates interface components
5. Testing & QA Specialist validates implementation
```

### 2. Bug Fix Across Projects
```
Input: "There's a memory leak in the LER import process that affects multiple projects"

Expected Flow:
1. Coordinator triages the issue
2. Data Integration Developer investigates LER import
3. Core AutoCAD Developer checks shared memory management
4. Testing & QA Specialist verifies fix doesn't introduce regressions
```

### 3. Refactoring Shared Components
```
Input: "Refactor the UtilitiesCommonSHARED project to improve performance"

Expected Flow:
1. Coordinator identifies impact scope
2. Core AutoCAD Developer plans refactoring
3. All affected specialists coordinate updates
4. Testing & QA Specialist ensures compatibility
```

## Best Practices

### 1. Specify Agent Roles
When requesting help, specify which agent should handle the task:
- ✅ "As the Civil 3D Specialist, implement a new hydraulic rule"
- ❌ "Implement a new hydraulic rule" (unclear who should handle)

### 2. Reference Project Structure
Be specific about which projects are affected:
- ✅ "Update both DimensioneringV2 and NorsynHydraulicShared"
- ❌ "Update the hydraulic stuff" (too vague)

### 3. Indicate Complexity Level
Help the swarm understand the scope:
- ✅ "This is a complex cross-project refactoring requiring coordination"
- ✅ "This is a simple bug fix in a single project"

### 4. Mention Dependencies
Call out when shared components are involved:
- ✅ "This change affects AutoCADCommandsSHARED, coordinate with all projects"
- ✅ "This is isolated to ExportBlocksToSvg only"

## Monitoring and Optimization

The swarm monitors:
- ✅ Task completion rates
- ✅ Agent utilization  
- ✅ Build success rates
- ✅ Memory usage

Auto-scaling triggers:
- 🔄 High workload → Spawn additional specialists
- 🔄 Low utilization → Consolidate agents
- 🔄 Complex tasks → Increase agent limits

## Files Created

1. **`claude_swarm_config.json`** - Complete swarm configuration
2. **`swarm_workflow.md`** - Detailed workflow documentation  
3. **`initialize_swarm_simple.ps1`** - Initialization script
4. **`logs/swarm_initialization.json`** - Monitoring log

## Integration with Development Workflow

The swarm configuration integrates with:
- ✅ Git repository (feature branch strategy)
- ✅ MSBuild system (automated builds)
- ✅ Solution structure (23 projects, 4 shared)
- ✅ Testing workflows

This swarm setup optimizes for the complex, multi-project nature of AutoCAD Civil 3D development while maintaining clear specialization and efficient resource allocation.