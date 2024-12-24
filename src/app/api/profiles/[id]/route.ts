import { NextResponse } from "next/server";
import { getServerSession } from "next-auth";
import { prisma } from "@/lib/prisma";
import { authOptions } from "../../auth/[...nextauth]/route";

// Get a specific profile
export async function GET(
  req: Request,
  { params }: { params: { id: string } }
) {
  try {
    const session = await getServerSession(authOptions);

    if (!session?.user?.id) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const profile = await prisma.profile.findUnique({
      where: {
        id: params.id,
        userId: session.user.id,
      },
    });

    if (!profile) {
      return NextResponse.json({ error: "Profile not found" }, { status: 404 });
    }

    return NextResponse.json(profile);
  } catch (error) {
    console.error("Error fetching profile:", error);
    return NextResponse.json(
      { error: "Failed to fetch profile" },
      { status: 500 }
    );
  }
}

// Update a profile
export async function PUT(
  req: Request,
  { params }: { params: { id: string } }
) {
  try {
    const session = await getServerSession(authOptions);

    if (!session?.user?.id) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const { name, calories, protein, carbs, fat } = await req.json();

    if (!name || !calories || !protein || !carbs || !fat) {
      return NextResponse.json(
        { error: "Missing required fields" },
        { status: 400 }
      );
    }

    const profile = await prisma.profile.update({
      where: {
        id: params.id,
        userId: session.user.id,
      },
      data: {
        name,
        calories,
        protein,
        carbs,
        fat,
      },
    });

    return NextResponse.json(profile);
  } catch (error) {
    console.error("Error updating profile:", error);
    return NextResponse.json(
      { error: "Failed to update profile" },
      { status: 500 }
    );
  }
}

// Delete a profile
export async function DELETE(
  req: Request,
  { params }: { params: { id: string } }
) {
  try {
    const session = await getServerSession(authOptions);

    if (!session?.user?.id) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    // Check if this is the user's last profile
    const profileCount = await prisma.profile.count({
      where: {
        userId: session.user.id,
      },
    });

    if (profileCount <= 1) {
      return NextResponse.json(
        { error: "Cannot delete the last profile" },
        { status: 400 }
      );
    }

    await prisma.profile.delete({
      where: {
        id: params.id,
        userId: session.user.id,
      },
    });

    return NextResponse.json({ message: "Profile deleted" });
  } catch (error) {
    console.error("Error deleting profile:", error);
    return NextResponse.json(
      { error: "Failed to delete profile" },
      { status: 500 }
    );
  }
}
