<?php

namespace App\UI\Game;

use Nette;
use App\Model\GameFacade;
use Nette\Application\UI\presenter;
use Nette\Application\UI\Form;

final class GamePresenter extends Nette\Application\UI\Presenter
{
	public function __construct(
		private GameFacade $facade,
	) {}

	public function renderShow(int $id): void
	{
		$game = $this->facade->getGameById($id);
		if (!$game) {
			$this->error('Stránka nebyla nalezena');
		}

		$this->template->game = $game;
	}

	public function renderDefault(): void
	{
		$this->template->games = $this->facade
			->getAllGame()
			->limit(30);
	}

	//Smazání her

	public function handleDeleteGame(int $gameId) {
		$this->facade->delete($gameId);
		$this->redirect("Game:default");
		$this->flashMessage("Hra byla úspěšně smazána!");
	}

	//Přidávání her

	protected function createComponentGameForm(): Form
	{
		$form = new Form;
		$form->addText('name', 'Název hry:')
			->setRequired();
		$form->addText('genre', 'Typ hry:')
			->setRequired();
		$form->addText('release', 'Vydání:')
			->setRequired();
		$form->addTextArea('description', 'Popis:')
			->setRequired();

		$form->addSubmit('send', 'Uložit a publikovat');
		$form->onSuccess[] = $this->gameFormSucceeded(...);

		return $form;
	}

	private function gameFormSucceeded(array $data): void
	{
		$gameId = $this->getParameter('gameId');

		if ($gameId) {
			$game = $this->facade->editGame($gameId, $data);
			$this->redirect('Game:show', $gameId);
			$this->flashMessage("Hra byla úspěšně přidána!");
		} else {
			$this->facade->insertGame($data);
		}

	}

	public function renderEdit(int $gameId): void
	{
		$game = $this->facade->getGameById($gameId);
		$this->template->post = $game;

		if (!$game) {
			$this->error('Post not found');
		}

		$this->getComponent('gameForm')
			->setDefaults($game->toArray());
	}

	//Úprava her


}
