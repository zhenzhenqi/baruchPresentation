using UnityEngine;
using System;

public class PlayerContoller : MonoBehaviour 
{

	public float speed = 800.0f;
	public Rigidbody rb;


	void FixedUpdate()
	{
		float moveHorizontal = Input.GetAxis ("Horizontal");
		float moveVertical = Input.GetAxis ("Vertical");

		Vector3 movement = new Vector3 (moveHorizontal, 0.0f, moveVertical);

		rb.AddForce (movement * speed * Time.deltaTime);
	}

	//to end game on ESC
	//void Update()
	//{
	//if (Input.GetKey(KeyCode.Escape))
	//{
	//	Application.Quit();
	//}

}