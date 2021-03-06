(* ::Package:: *)

(* ::Subsection::Closed:: *)
(*Description*)


(* ::Text:: *)
(*These are various test for "HeatTrans" paclet.*)


(* "HeatTrans.wl" must be loaded before running these tests, otherwise testing is aborted. *)
If[
	Not@MemberQ[$Packages,"HeatTrans`"],
	Print["Error: Package is not loaded!"];Abort[];
];


(* Currently it is unclear what this line does, it is automatically gnerated during conversion to .wlt *)
BeginTestSection["Tests"]


(* ::Subsection::Closed:: *)
(*MakeMesh*)


VerificationTest[
	With[{mesh=MakeMesh[Disk[],1]},
		(* Test should return True *)
		And[
			Head@First@mesh["MeshElements"]==QuadElement,
			mesh["MeshOrder"]==1
		]
	],
	TestID->"MakeMesh_success_order=1"
]


VerificationTest[
	With[{mesh=MakeMesh[Disk[],2]},
		(* Test should return True *)
		And[
			Head@First@mesh["MeshElements"]==QuadElement,
			mesh["MeshOrder"]==2
		]
	],
	TestID->"MakeMesh_success_order=2"
]


VerificationTest[
	MakeMesh[Disk[],"badValue"],
	MakeMesh[Disk[],"badValue"],
	TestID->"MakeMesh_badMeshOrder"
]


VerificationTest[
	MakeMesh[Ball[],1],
	$Failed,
	\!\(\*
TagBox[
RowBox[{"{", 
StyleBox[
RowBox[{"MakeMesh", "::", "badreg"}], "MessageName"], "}"}],
Short[#, Rational[2, 3]]& ]\),
	TestID->"MakeMesh_fail_3D_region"
]


VerificationTest[
	MakeMesh[HalfPlane[{{0,0},{1,0}},{0,1}],1],
	$Failed,
	\!\(\*
TagBox[
RowBox[{"{", 
StyleBox[
RowBox[{"MakeMesh", "::", "badreg"}], "MessageName"], "}"}],
Short[#, Rational[2, 3]]& ]\),
	TestID->"MakeMesh_fail_unbounded_region"
]


(* ::Subsection::Closed:: *)
(*HeatTransfer*)


With[{
	mesh=ToElementMesh[
		"Coordinates"->{{1.,0.},{1.,1.},{1.5,0.},{1.5,1.},{2.,0.},{2.,1.},{1.,0.5},{1.4,0.4},{2.,0.5}}, 
		"MeshElements"->{QuadElement[{{1,3,8,7},{7,8,4,2},{3,5,9,8},{8,9,6,4}}]}
	]
	},
	VerificationTest[
		HeatTransfer[mesh,1,$DefaultMaterial,"NoTimeSteps"->2],
		_InterpolatingFunction,
		SameTest->MatchQ,
		TestID->"HeatTransfer_success"
	]
]


VerificationTest[
	HeatTransfer[ToElementMesh@Disk[],1,$DefaultMaterial],
	$Failed,
	\!\(\*
TagBox[
RowBox[{"{", 
StyleBox[
RowBox[{"HeatTransfer", "::", "quadElms"}], "MessageName"], "}"}],
Short[#, Rational[2, 3]]& ]\),
	TestID->"HeatTransfer_fail_triangleElements"
]


VerificationTest[
	HeatTransfer[Disk[],1,$DefaultMaterial,"NoTimeSteps"->-2],
	$Failed,
	\!\(\*
TagBox[
RowBox[{"{", 
RowBox[{"HeatTransfer", "::", "timeSteps"}], "}"}],
Short[#, Rational[2, 3]]& ]\),
	TestID->"HeatTransfer_fail_noTimeSteps"
]


(* ::Subsection::Closed:: *)
(*EndTestSection*)


EndTestSection[]
