oDesktop.RestoreWindow()

oProject = oDesktop.SetActiveProject("ansys")
oDesign = oProject.SetActiveDesign("Maxwell3DDesign1")

oModule = oDesign.GetModule("FieldsReporter")

oModule.CopyNamedExprToStack("E_Vector")
oModule.ExportOnGrid("efield.fld", 
	["-10mm", "-10mm", "-3m"], 
	["10mm", "10mm", "3m"], 
	["0.1mm", "0.1mm", "0.1mm"], 
	"E_Field : LastAdaptive", 
	[], True, "Cartesian", 
	["0mm", "0mm", "0mm"])
oModule.CalcStack("pop")

oModule.CopyNamedExprToStack("Voltage")
oModule.ExportOnGrid("voltage.fld", 
	["-10mm", "-10mm", "-3m"], 
	["10mm", "10mm", "3m"], 
	["0.1mm", "0.1mm", "0.1mm"], 
	"E_Field : LastAdaptive", 
	[], True, "Cartesian", 
	["0mm", "0mm", "0mm"])


oDesign = oProject.SetActiveDesign("HFSSDesign1")

oModule = oDesign.GetModule("ReportSetup")

oModule.UpdateAllReports()
oModule.ExportToFile("Vertical Polarization", "vert.csv")
oModule.ExportToFile("Horizontal Polarization", "horiz.csv")


