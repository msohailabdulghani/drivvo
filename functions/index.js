/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const { onRequest } = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const admin = require("firebase-admin");

// Initialize Firebase Admin SDK
admin.initializeApp();

/**
 * Cloud Function to create a new user with email and password
 * This uses Firebase Admin SDK so the calling user doesn't get signed out
 * Using onRequest with public access for maximum compatibility
 */
exports.createUser = onRequest(
  {
    cors: true,
    region: "us-central1",
    // Allow unauthenticated access - security is handled via adminId validation in Firestore
    invoker: "public"
  },
  async (req, res) => {
    // Log the request for debugging
    logger.info("createUser HTTP function called");
    logger.info("Method:", req.method);

    // Only allow POST requests
    if (req.method !== "POST") {
      res.status(405).json({ success: false, message: "Method not allowed" });
      return;
    }

    try {
      const { email, password, firstName, lastName, userType, adminId } = req.body;

      logger.info("Request data received:", { email, firstName, lastName, userType, adminId });

      // Validate adminId is provided (required for security)
      if (!adminId) {
        logger.warn("No adminId provided");
        res.status(400).json({
          success: false,
          message: "Admin ID is required."
        });
        return;
      }

      // Verify the admin exists in Firestore (security check)
      const adminDoc = await admin.firestore()
        .collection("UserProfile")
        .doc(adminId)
        .get();

      if (!adminDoc.exists) {
        logger.warn("Admin not found:", adminId);
        res.status(403).json({
          success: false,
          message: "Invalid admin ID."
        });
        return;
      }

      logger.info("Admin verified:", adminId);

      // Validate required fields
      if (!email || !password) {
        res.status(400).json({
          success: false,
          message: "Email and password are required."
        });
        return;
      }

      // Create the user in Firebase Auth using Admin SDK
      const userRecord = await admin.auth().createUser({
        email: email,
        password: password,
        displayName: `${firstName || ""} ${lastName || ""}`.trim(),
      });

      logger.info("Successfully created new user:", userRecord.uid);

      // Create user profile document in Firestore
      const userProfileData = {
        id: userRecord.uid,
        email: email,
        first_name: firstName || "",
        last_name: lastName || "",
        sign_in_method: "email",
        user_type: userType || "",
        admin_id: adminId || "",
        created_at: admin.firestore.FieldValue.serverTimestamp(),
      };

      await admin.firestore()
        .collection("UserProfile")
        .doc(userRecord.uid)
        .set(userProfileData);

      logger.info("Successfully created user profile in Firestore");

      res.status(200).json({
        success: true,
        uid: userRecord.uid,
        message: "User created successfully",
      });
    } catch (error) {
      logger.error("Error creating new user:", error);

      // Handle specific Firebase Auth errors
      if (error.code === "auth/email-already-exists") {
        res.status(409).json({
          success: false,
          code: "already-exists",
          message: "The email address is already in use by another account."
        });
        return;
      }
      if (error.code === "auth/invalid-email") {
        res.status(400).json({
          success: false,
          code: "invalid-argument",
          message: "The email address is not valid."
        });
        return;
      }
      if (error.code === "auth/weak-password") {
        res.status(400).json({
          success: false,
          code: "invalid-argument",
          message: "The password is too weak."
        });
        return;
      }

      res.status(500).json({
        success: false,
        code: "internal",
        message: error.message || "An error occurred while creating the user."
      });
    }
  }
);
